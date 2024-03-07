################################################################################
## account
################################################################################
data "aws_caller_identity" "this" {}

data "aws_ssm_parameter" "fluentbit_role" {
  name = "/${var.namespace}/${var.environment}/fluentbit_role"
}
################################################################################
## opensearch data
################################################################################
data "aws_ssm_parameter" "opensearch_domain" {
  name = "/${var.namespace}/${var.environment}/opensearch/domain_endpoint"
}

data "aws_ssm_parameter" "opensearch_username" {
  name = "/${var.namespace}/${var.environment}/opensearch/admin_username"
}

data "aws_ssm_parameter" "opensearch_password" {
  name = "/${var.namespace}/${var.environment}/opensearch/admin_password"
}