variable "tags" {
  type        = map(string)
  description = "Tags to assign the security groups."
}

variable "parameter_defaults" {
  type        = map(any)
  description = "Parameter write default settings"
  default = {
    description = null
    type        = "SecureString"
    tier        = "Standard"
    overwrite   = "false"
  }
}

variable "ssm_parameters" {
  type        = list(map(string))
  description = "List of maps with the parameter values to write to SSM Parameter Store"
  default     = []
}