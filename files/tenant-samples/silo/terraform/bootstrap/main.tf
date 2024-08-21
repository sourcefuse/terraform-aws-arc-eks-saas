################################################
## imports
################################################
data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}
################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.76.1"
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

  extra_tags = {
    Tenant    = var.tenant
    Tenant_ID = var.tenant_id
    Tier = var.tenant_tier
  }
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

  bucket_name   = "${var.namespace}-${var.environment}-${var.tenant_tier}-${var.tenant}-terraform-state-${module.bucket_suffix.result}"
  dynamodb_name = "${var.namespace}-${var.environment}-${var.tenant_tier}-${var.tenant}-terraform-state-lock"

  tags = merge(module.tags.tags, tomap({
    Name         = "${var.namespace}-${var.environment}-${var.tenant_tier}-${var.tenant}-terraform-state-${module.bucket_suffix.result}"
    DynamoDBName = "${var.namespace}-${var.environment}-${var.tenant_tier}-${var.tenant}-terraform-state-lock"
  }))
}



#########################################################################################
## Put Resource name in Parameter Store
#########################################################################################
module "bootstrap_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/terraform-state-bucket"
      value       = module.bootstrap.bucket_name
      type        = "String"
      overwrite   = "true"
      description = "Terraform State Bucket Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/terraform-state-dynamodb-table"
      value       = module.bootstrap.dynamodb_name
      type        = "String"
      overwrite   = "true"
      description = "Terraform State Dynamodb Table"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.bootstrap, module.bucket_suffix]
}
