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
#########################################################################################
## DynamoDB Table to store tenant details
#########################################################################################
locals {
  dynamo_kms_master_key_id = var.dynamo_kms_master_key_id == null ? "" : var.dynamo_kms_master_key_id
}

resource "aws_dynamodb_table" "tenant_details" {
  name           = "${var.namespace}-${var.environment}-tenant-details"
  hash_key       = var.dynamodb_hash_key
  read_capacity  = 5
  write_capacity = 5

  server_side_encryption {
    enabled     = true
    kms_key_arn = local.dynamo_kms_master_key_id
  }

  attribute {
    name = var.dynamodb_hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.enable_dynamodb_point_in_time_recovery
  }

  tags = merge(module.tags.tags, tomap({
    Name = "${var.namespace}-${var.environment}-tenant-details",
  }))
}


#########################################################################################
## Put Resource name in Parameter Store
#########################################################################################
module "bootstrap_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/terraform-state-bucket"
      value       = module.bootstrap.bucket_name
      type        = "String"
      overwrite   = "true"
      description = "Terraform State Bucket Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/terraform-state-dynamodb-table"
      value       = module.bootstrap.dynamodb_name
      type        = "String"
      overwrite   = "true"
      description = "Terraform State Dynamodb Table"
    },
    {
      name        = "/${var.namespace}/${var.environment}/artifact-bucket"
      value       = resource.aws_s3_bucket.artifact_bucket.bucket
      type        = "String"
      overwrite   = "true"
      description = "Codepipeline Artifact Bucket"
    },
    {
      name        = "/${var.namespace}/${var.environment}/tenant-details-dynamodb-table"
      value       = resource.aws_dynamodb_table.tenant_details.id
      type        = "String"
      overwrite   = "true"
      description = "Tenant Details DynamoDB Table"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.bootstrap, aws_s3_bucket.artifact_bucket, module.bucket_suffix]
}
