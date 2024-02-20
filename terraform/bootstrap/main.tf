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