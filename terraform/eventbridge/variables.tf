################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}