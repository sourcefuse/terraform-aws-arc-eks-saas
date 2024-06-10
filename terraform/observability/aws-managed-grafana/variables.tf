################################################################################
## shared
################################################################################
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

#################################################################################
## Grafana
#################################################################################
variable "grafana_version" {
  description = "AWS Managed grafana version"
  type        = string
  default     = "9.4"
}

variable "workspace_api_keys_keyname" {
  description = "Workspace api key base key name"
  type        = string
  default     = "admin"
}

variable "workspace_api_keys_keyrole" {
  description = "Workspace api key base key role like ADMIN, VIEWER, EDITOR etc"
  type        = string
  default     = "ADMIN"
}

variable "workspace_api_keys_ttl" {
  description = "Workspace api key base key  time to live in seconds . Specifies the time in seconds until the API key expires. Keys can be valid for up to 30 days"
  type        = number
  default     = 9000
}

variable "domain_name" {
  description = "Domain Name "
  type        = string
  default     = "arc-saas.net"
}