################################################################################
## shared
################################################################################
variable "region" {
  type        = string
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

variable "tenant" {
  type        = string
  description = "tenant name"
}

variable "tenant_id" {
  type        = string
  description = "Tenat unique ID"
}

variable "domain_name" {
  description = "Enter Defeault Redirect URL"
  type        = string
  default     = ""
}

#################################################################################
## Helm
#################################################################################
variable "tenant_email" {
  type        = string
  description = "tenant Email"
}

variable "user_name" {
  type        = string
  description = "cognito user"
}

variable "tenant_name" {
  type        = string
  description = "Tenant Name"
}

variable "tenant_secret" {
  type        = string
  description = "tenant secret"
}

variable "tenant_client_id" {
  type        = string
  description = "tenant Client ID"
}

variable "tenant_client_secret" {
  type        = string
  description = "tenant Client Secret"
}

variable "user_callback_secret" {
  type = string 
  description = "Secret for user tenant service"
}

variable "karpenter_role" {
  type        = string
  description = "EKS Karpenter Role"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "tenant_host_domain" {
  type        = string
  description = "tenant Host"
}

variable "jwt_issuer" {
  type        = string
  description = "jwt issuer"
}

variable "alb_url" {
  type        = string
  description = "ALB DNS Record"
}