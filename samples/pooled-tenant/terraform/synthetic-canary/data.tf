#############################################################################
## Data Import
#############################################################################
data "aws_partition" "this" {}

data "aws_caller_identity" "current" {}


data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Type"

    values = ["private"]
  }
  filter {
    name = "tag:Environment"

    values = ["${var.environment}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Type"

    values = ["public"]
  }
  filter {
    name = "tag:Environment"

    values = ["${var.environment}"]
  }
}

data "aws_ssm_parameter" "canary_report_bucket" {
  name = "/${var.namespace}/${var.environment}/canary/report-bucket"
}

data "aws_ssm_parameter" "canary_security_group" {
  name = "/${var.namespace}/${var.environment}/canary/security-group"
}

data "aws_ssm_parameter" "canary_role" {
  name = "/${var.namespace}/${var.environment}/canary/role"
}