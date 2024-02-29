################################################################################
## data lookups
################################################################################
data "aws_caller_identity" "this" {}

data "aws_ssm_parameter" "db_host" {
  name = "/${var.namespace}/${var.environment}/db_host"
}

data "aws_ssm_parameter" "db_user" {
  name = "/${var.namespace}/${var.environment}/db_user"
}

data "aws_ssm_parameter" "db_password" {
  name = "/${var.namespace}/${var.environment}/db_password"
}

data "aws_ssm_parameter" "db_port" {
  name = "/${var.namespace}/${var.environment}/db_port"
}