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

################################################################################
## db operation variables
################################################################################
variable "aurora_db_name" {
  type        = string
  default     = "auroradb"
  description = "Database name."
}

##################################################################################
## Postgres DBs
##################################################################################
variable "auditdbdatabase" {
  type    = string
  default = "audit"
}

variable "authenticationdbdatabase" {
  type    = string
  default = "auth"
}

variable "notificationdbdatabase" {
  type    = string
  default = "notification"
}

variable "subscriptiondbdatabase" {
  type    = string
  default = "subscription"
}

variable "userdbdatabase" {
  type    = string
  default = "user"
}

variable "paymentdbdatabase" {
  type    = string
  default = "payment"
}

variable "tenantmgmtdbdatabase" {
  type    = string
  default = "tenantmgmt"
}

variable "featuretoggledbdatabase" {
  type    = string
  default = "feature"
}