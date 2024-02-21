################################################
## imports
################################################
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}
################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }

  //backend "s3" {}
}

provider "aws" {
  region = var.region
}

################################################################################
## Tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

################################################################################
## backend state configuration
################################################################################
resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}

module "bootstrap" {
  source  = "sourcefuse/arc-bootstrap/aws"
  version = "1.1.3"

  bucket_name   = "${var.namespace}-${var.environment}-terraform-state-${resource.random_string.bucket_suffix.result}"
  dynamodb_name = "${var.namespace}-${var.environment}-terraform-state-lock"

  tags = merge(module.tags.tags, tomap({
    Name         = "${var.namespace}-${var.environment}-terraform-state-${resource.random_string.bucket_suffix.result}"
    DynamoDBName = "${var.namespace}-${var.environment}-terraform-state-lock"
  }))
}

################################################################################
## Store terraform state bucket in parameter store
################################################################################
resource "aws_ssm_parameter" "tf_state_bucket" {
  name        = "/${var.namespace}/${var.environment}/terraform-state-bucket"
  description = "Terraform State Bucket Name"
  type        = "String"
  overwrite   = true
  value       = module.bootstrap.bucket_name
  depends_on  = [resource.random_string.bucket_suffix, module.bootstrap]
  tags        = module.tags.tags
}

resource "aws_ssm_parameter" "tf_state_table" {
  name        = "/${var.namespace}/${var.environment}/terraform-state-dynamodb-table"
  description = "Terraform State Dynamodb Table"
  type        = "String"
  overwrite   = true
  value       = module.bootstrap.dynamodb_name
  depends_on  = [module.bootstrap]
  tags        = module.tags.tags
}

################################################################################
## Artifact S3 Bucket Creation
################################################################################
locals {
  bucket_arn = "arn:${data.aws_partition.current.partition}:s3:::${var.namespace}-${var.environment}-artifact-bucket-${random_string.bucket_suffix.result}"
  depends_on = [resource.random_string.bucket_suffix]
}

data "aws_iam_policy_document" "policy" {
  ## Enforce SSL/TLS on all objects
  statement {
    sid    = "enforce-tls"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = ["${local.bucket_arn}/*"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "inventory-and-analytics"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${local.bucket_arn}/*"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [local.bucket_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket" "artifact_bucket" {
  bucket        = "${var.namespace}-${var.environment}-artifact-bucket-${resource.random_string.bucket_suffix.result}"
  policy        = data.aws_iam_policy_document.policy.json
  force_destroy = true

  depends_on = [resource.random_string.bucket_suffix]
  tags = merge(module.tags.tags, tomap({
    type = "artifact"
  }))
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.artifact_bucket.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
  depends_on = [resource.aws_s3_bucket.artifact_bucket]
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.artifact_bucket.id

  ## Block new public ACLs and uploading public objects
  block_public_acls = true

  ## Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  ## Block new public bucket policies
  block_public_policy = true

  ## Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true

  depends_on = [resource.aws_s3_bucket.artifact_bucket]
}

# store artifact bucket in parameter store 

resource "aws_ssm_parameter" "artifact_bucket" {
  name        = "/${var.namespace}/${var.environment}/artifact-bucket"
  description = "Codepipeline Artifact Bucket"
  type        = "String"
  overwrite   = true
  value       = resource.aws_s3_bucket.artifact_bucket.bucket
  depends_on  = [aws_s3_bucket.artifact_bucket]
  tags        = module.tags.tags
}