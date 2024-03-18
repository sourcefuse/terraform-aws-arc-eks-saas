variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "namespace" {
  description = "Namespace the resource belongs in."
  default     = "arc-saas"
  type        = string
}

variable "environment" {
  default     = "dev"
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
  type        = string
}