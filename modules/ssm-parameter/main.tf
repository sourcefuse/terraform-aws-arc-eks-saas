################################################################
## SSM
################################################################

resource "aws_ssm_parameter" "default" {
  for_each = local.ssm_parameters
  name     = each.key

  description = each.value.description
  type        = each.value.type
  tier        = each.value.tier
  value       = each.value.value
  overwrite   = each.value.overwrite

  tags = var.tags
}