locals {
  fluentbit_role = ["${data.aws_ssm_parameter.fluentbit_role.value}"]
}