################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "map_additional_iam_roles" {
  type = list(object({
    groups    = list(string)
    role_arn  = string
    user_name = string
  }))
  default = []
}

variable "map_additional_iam_users" {
  type = list(object({
    groups    = list(string)
    user_arn  = string
    user_name = string
  }))
  default = []
}

variable "map_aws_accounts" {
  type    = list(string)
  default = []
}