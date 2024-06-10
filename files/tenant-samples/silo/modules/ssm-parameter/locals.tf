locals {
  ssm_parameters = { for e in var.ssm_parameters : e.name => merge(var.parameter_defaults, e) }
}