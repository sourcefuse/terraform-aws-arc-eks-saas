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

resource "aws_ssm_parameter" "this" {
  dynamic "ssm" {
    for_each = var.ssm_parameters
    content {
      name        = ssm.value.name
      type        = ssm.value.type
      overwrite   = ssm.value.overwrite
      value       = ssm.value.value
      description = ssm.value.value
      tags        = var.tags
    }
  }
  #   for_each = { for index, ssm_parameter in var.ssm_parameters :
  #   ssm_parameter.name => ssm_parameter }
  #   name        = each.value.name
  #   type        = each.value.type
  #   overwrite   = each.value.overwrite
  #   value       = each.value.value
  #   description = each.value.value

  #tags = var.tags
}

# resource "aws_ssm_parameter" "ssm_parameter" {

#   name        = var.ssm_parameter_name
#   description = var.ssm_parameter_description
#   type        = var.ssm_parameter_type
#   overwrite   = var.ssm_parameter_overwrite
#   value       = var.ssm_parameter_value

#   tags = var.tags

# }