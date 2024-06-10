################################################################################
## shared
################################################################################
variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
}

################################################################################
## opensearch operations
################################################################################
variable "backend_roles" {
  type        = list(string)
  description = "List of IAM Roles which need to be mapped to opensearch"
  default     = []
}