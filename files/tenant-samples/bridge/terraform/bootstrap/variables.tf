variable "region" {
  description = "AWS Region"
  type        = string
}

variable "namespace" {
  description = "Namespace the resource belongs in."
  type        = string
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "tenant_tier" {
  type = string
  description = "Tenant Tier"
}