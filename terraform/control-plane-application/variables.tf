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
## control plane
################################################################################
variable "jwt_issuer" {
  type        = string
  description = "JWT Issuer"
  default     = "control-plane"
}

variable "user_name" {
  type        = string
  description = "cognito User Name"
}

variable "tenant_name" {
  type        = string
  description = "Enter Default Tenant Name"
}

variable "tenant_email" {
  type        = string
  description = "Enter Default Tenant Email ID"
}

variable "domain_name" {
  type        = string
  description = "Enter Registered Domain Name"
}

variable "from_email" {
  type        = string
  description = "Enter the email from where notification will be sent. it should have contain verified ses domain identity"
}