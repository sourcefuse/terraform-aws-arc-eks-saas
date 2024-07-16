################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

############################################################################
## DynamoDB 
############################################################################
variable "dynamodb_hash_key" {
  type        = string
  description = "The attribute to use as the hash (partition) key for tenant dynamodb table."
  default     = "tier"
}

variable "enable_dynamodb_point_in_time_recovery" {
  description = "Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables."
  type        = bool
  default     = true
}

variable "dynamo_kms_master_key_id" {
  type        = string
  description = "The Default ID of an AWS-managed customer master key (CMK) for Amazon Dynamo"
  default     = null
}

#############################################################################
## Extra Variables
#############################################################################
variable "domain_name" {
  type        = string
  default     = ""
  description = "Domain name of the control plane"
}

variable "control_plane_host" {
  type        = string
  description = "Host Name of the control plane"
}