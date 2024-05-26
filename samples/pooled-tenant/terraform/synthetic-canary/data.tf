#############################################################################
## Data Import
#############################################################################
data "aws_partition" "this" {}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "canary_report_bucket" {
  name = "/${var.namespace}/${var.environment}/canary/report-bucket"
}

data "aws_ssm_parameter" "canary_security_group" {
  name = "/${var.namespace}/${var.environment}/canary/security-group"
}

data "aws_ssm_parameter" "canary_role" {
  name = "/${var.namespace}/${var.environment}/canary/role"
}