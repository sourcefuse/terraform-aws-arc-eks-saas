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
  default     = "sourcefuse"
}

variable "tenant_name" {
  type        = string
  description = "Enter Default Tenant Name"
  default     = "SOURCEFUSE"
}

variable "tenant_email" {
  type        = string
  description = "Enter Default Tenant Email ID"
  default     = "harshit.kumar+1@sourcefuse.com"
}


variable "control_plane_host" {
  type        = string
  description = "Enter control plane host where application will be deployed"
  default     = "arc-saas.net"
}
