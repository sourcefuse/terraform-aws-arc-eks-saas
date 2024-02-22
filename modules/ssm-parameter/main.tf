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
  for_each = local.ssm_parameters
  name     = each.key

  description = each.value.description
  type        = each.value.type
  tier        = each.value.tier
  value       = each.value.value
  overwrite   = each.value.overwrite

  tags = module.this.tags
}


# resource "aws_ssm_parameter" "ssm_parameter" {

#   name        = var.ssm_parameter_name
#   description = var.ssm_parameter_description
#   type        = var.ssm_parameter_type
#   overwrite   = var.ssm_parameter_overwrite
#   value       = var.ssm_parameter_value

#   tags = var.tags

# }