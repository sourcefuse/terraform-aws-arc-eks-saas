# variable "ssm_parameter_name" {
#   type        = string
#   description = "Name of SSM Parameter"
#   default     = "my-ssm-parameter"
# }

# variable "ssm_parameter_description" {
#   type        = string
#   description = "Description of SSM Parameter"
#   default     = "my-ssm-parameter"
# }

# variable "ssm_parameter_type" {
#   type        = string
#   description = "Type of the parameter. Valid types are String, StringList and SecureString"
#   default     = "String"
# }

# variable "ssm_parameter_overwrite" {
#   type        = bool
#   description = "Overwrite an existing parameter"
#   default     = false
# }

# variable "ssm_parameter_value" {
#   type        = string
#   description = "Value of the parameter"
#   default     = ""
# }



variable "tags" {
  type        = map(string)
  description = "Tags to assign the security groups."
}

variable "parameter_write_defaults" {
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