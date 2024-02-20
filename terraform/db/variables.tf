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
  default     = "dev"
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
  default     = "arc-saas"
}

################################################################################
## db
################################################################################
variable "aurora_cluster_enabled" {
  type        = bool
  description = "Enable creation of an Aurora Cluster"
  default     = true
}

variable "aurora_db_admin_username" {
  type        = string
  description = "Name of the default DB admin user role"
  default     = ""
}
