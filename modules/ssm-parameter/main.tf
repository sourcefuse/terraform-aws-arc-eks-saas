################################################################
## defaults
################################################################
terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ssm_parameter" "default" {
  for_each = var.ssm_parameters
  name     = each.key

  description = each.value.description
  type        = each.value.type
  tier        = each.value.tier
  key_id      = each.value.type == "SecureString" && length(var.kms_arn) > 0 ? var.kms_arn : ""
  value       = each.value.value
  # Note on the deprecation warning:
  # Configurations expecting the standard update flow will need to keep overwrite = true set
  # until this becomes the default behavior in v6.0.0. Removing it in v5.X will result in
  # the default value of false, preventing the parameter value from being updated.
  # Source: https://github.com/hashicorp/terraform-provider-aws/issues/25636#issuecomment-1623661159
  overwrite       = each.value.overwrite
  allowed_pattern = each.value.allowed_pattern
  data_type       = each.value.data_type

  tags = module.this.tags
}


resource "aws_ssm_parameter" "ssm_parameter" {

  name        = var.ssm_parameter_name
  description = var.ssm_parameter_description
  type        = var.ssm_parameter_type
  overwrite   = var.ssm_parameter_overwrite
  value       = var.ssm_parameter_value

  tags = var.tags

}