data "aws_ssm_parameter" "api_gw_url" {
    name = "/${var.namespace}/${var.environment}/api_gw_arn"
} 