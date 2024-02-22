
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

variable "ssm_parameters" {
  type = map(map(object({
    name        = string
    description = string
    type        = string
    value       = string
    overwrite   = bool
  })))
  description = "configuration block for ssm parameter"
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign the security groups."
}