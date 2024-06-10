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

##################################################################################
## istio
##################################################################################
variable "min_pods" {
  type        = number
  description = "The minimum number of pods to maintain for the Istio ingress gateway. This ensures basic availability and load handling."
}

variable "max_pods" {
  type        = number
  description = "The maximum number of pods to scale up for the Istio ingress gateway. This limits the resources used and manages the scaling behavior."
}

variable "common_name" {
  type        = string
  description = " Domain Name  supplied as commn name."
}

variable "organization" {
  type        = string
  description = " Organization name supplied as common name."
}

variable "alb_ingress_name" {
  type        = string
  description = " The ALB Ingress name by which the load balancer will be created."
  default     = ""
}

variable "acm_certificate_arn" {
  type        = string
  description = " AWS CertificateMmanager Certificate ARN for the AWS LoadBalancer."
}

variable "full_domain_name" {
  type        = string
  description = "Domain  with wildcard   example >>   *.domain.in "
}