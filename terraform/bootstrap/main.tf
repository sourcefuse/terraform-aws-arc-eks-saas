################################################
## imports
################################################
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}
################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.4"

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
module "bucket_suffix" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}


module "bootstrap" {
  source  = "sourcefuse/arc-bootstrap/aws"
  version = "1.1.3"

  bucket_name   = "${var.namespace}-${var.environment}-terraform-state-${module.bucket_suffix.result}"
  dynamodb_name = "${var.namespace}-${var.environment}-terraform-state-lock"

  tags = merge(module.tags.tags, tomap({
    Name         = "${var.namespace}-${var.environment}-terraform-state-${module.bucket_suffix.result}"
    DynamoDBName = "${var.namespace}-${var.environment}-terraform-state-lock"
  }))
}

################################################################################
## Store terraform state bucket in parameter store
################################################################################
module "tf_state_bucket" {
  source                    = "../../modules/ssm-parameter"
  ssm_parameter_name        = "/${var.namespace}/${var.environment}/terraform-state-bucket"
  ssm_parameter_description = "Terraform State Bucket Name"
  ssm_parameter_type        = "String"
  ssm_parameter_overwrite   = true
  ssm_parameter_value       = module.bootstrap.bucket_name
  tags                      = module.tags.tags
  depends_on                = [module.bucket_suffix, module.bootstrap]
}

module "tf_state_table" {
  source                    = "../../modules/ssm-parameter"
  ssm_parameter_name        = "/${var.namespace}/${var.environment}/terraform-state-dynamodb-table"
  ssm_parameter_description = "Terraform State Dynamodb Table"
  ssm_parameter_type        = "String"
  ssm_parameter_overwrite   = true
  ssm_parameter_value       = module.bootstrap.dynamodb_name
  tags                      = module.tags.tags
  depends_on                = [module.bucket_suffix, module.bootstrap]
}

################################################################################
## Artifact S3 Bucket Creation
################################################################################
locals {
  bucket_arn = "arn:${data.aws_partition.current.partition}:s3:::${var.namespace}-${var.environment}-artifact-bucket-${module.bucket_suffix.result}"
  depends_on = [module.bucket_suffix]
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
  bucket        = "${var.namespace}-${var.environment}-artifact-bucket-${module.bucket_suffix.result}"
  policy        = data.aws_iam_policy_document.policy.json
  force_destroy = true

  depends_on = [module.bucket_suffix]
  tags = merge(module.tags.tags, tomap({
    type = "artifact"
  }))
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.artifact_bucket.id
  versioning_configuration {
    status = "Enabled"
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
module "tf_state_table" {
  source                    = "../../modules/ssm-parameter"
  ssm_parameter_name        = "/${var.namespace}/${var.environment}/artifact-bucket"
  ssm_parameter_description = "Codepipeline Artifact Bucket"
  ssm_parameter_type        = "String"
  ssm_parameter_overwrite   = true
  ssm_parameter_value       = resource.aws_s3_bucket.artifact_bucket.bucket
  tags                      = module.tags.tags
  depends_on                = [aws_s3_bucket.artifact_bucket]
}