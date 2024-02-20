################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

################################################################################
## db
################################################################################
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "aurora" {
  source  = "sourcefuse/arc-db/aws"
  version = "2.0.5"


  environment = var.environment
  namespace   = var.namespace
  region      = var.region
  vpc_id      = data.aws_vpc.vpc.id

  aurora_cluster_enabled                    = var.aurora_cluster_enabled
  aurora_cluster_name                       = "${var.namespace}-${var.environment}-aurora"
  enhanced_monitoring_name                  = "${var.namespace}-${var.environment}-enhanced-monitoring"
  aurora_db_admin_username                  = each.value.aurora_db_admin_username
  aurora_db_name                            = each.value.aurora_db_name
  aurora_allow_major_version_upgrade        = each.value.aurora_allow_major_version_upgrade
  aurora_auto_minor_version_upgrade         = each.value.aurora_auto_minor_version_upgrade
  aurora_instance_type                      = each.value.aurora_instance_type
  aurora_subnets                            = data.aws_subnets.private.ids
  aurora_engine                             = each.value.aurora_engine
  aurora_engine_version                     = each.value.aurora_engine_version
  aurora_serverlessv2_scaling_configuration = var.aurora_serverlessv2_scaling_configuration
  aurora_allowed_cidr_blocks                = [data.aws_vpc.vpc.cidr_block]
  performance_insights_enabled              = each.value.performance_insights_enabled
  performance_insights_retention_period     = each.value.performance_insights_retention_period
  iam_database_authentication_enabled       = each.value.iam_database_authentication_enabled
  aurora_cluster_size                       = 1
  tags = merge(
    module.tags.tags
  )
}