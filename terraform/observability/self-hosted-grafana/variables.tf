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

################################################################################
## Grafana
################################################################################
variable "grafana_namespace" {
  description = "grafana namespace in which grafna will be deployed"
  type        = string
  default     = "grafana"
}

variable "service_account_name" {
  description = "Service Account Name"
  type        = string
  default     = "grafana"
}

variable "grafana_helm_release_version" {
  description = "Grafana helm release version"
  type        = string
  default     = "7.3.0"
}

variable "grafana_admin_username" {
  description = "Grafana admin login username"
  type        = string
  default     = "adminuser"
}

variable "grafana_volume_size" {
  description = "Grafana persistant volume size"
  type        = string
  default     = "10Gi"
}

variable "grafana_service_type" {
  description = "Grafana Service type Loadbalancer in our type "
  type        = string
  default     = "Loadbalancer"
}

variable "domain_name" {
  description = "Domain Name "
  type        = string
  default     = "arc-saas.net"
}