variable "region" {
  description = "AWS Region"
  type        = string
}


variable "grafana_version" {
  description = "AWS Managed grafana version"
  type        = string
}

variable "workspace_api_keys_keyname" {
  description = "Workspace api key base key name"
  type        = string
}

variable "workspace_api_keys_keyrole" {
  description = "Workspace api key base key role like ADMIN, VIEWER, EDITOR etc"
  type        = string
}

variable "workspace_api_keys_ttl" {
  description = "Workspace api key base key  time to live in seconds . Specifies the time in seconds until the API key expires. Keys can be valid for up to 30 days"
  type        = number
}