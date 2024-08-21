data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "db_arn" {
    name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_arn"
}