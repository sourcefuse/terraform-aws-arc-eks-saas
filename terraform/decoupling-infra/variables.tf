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

############################################################################
## Lambda
############################################################################
variable "compatible_architectures" {
  description = "Lambda layer compatible architectures"
  type        = list(string)
  default     = ["x86_64"]
}

variable "timeout" {
  type        = number
  description = "Lambda function timeout in seconds"
  default     = 300
}

variable "environment_variables" {
  type        = map(any)
  description = "env variables for the code"
  default     = {}
}

variable "memory_size" {
  type        = number
  description = "Memory size for Lambda function"
  default     = 1024
}

variable "ephemeral_storage_size" {
  description = "Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB)."
  type        = number
  default     = 1024
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1."
  type        = number
  default     = -1
}

variable "maximum_retry_attempts" {
  description = "Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2."
  type        = number
  default     = 0
}
############################################################################
## API Gateway
############################################################################
variable "logging_level" {
  type        = string
  description = "The logging level of the API. One of - OFF, INFO, ERROR"
  default     = "INFO"

  validation {
    condition     = contains(["OFF", "INFO", "ERROR"], var.logging_level)
    error_message = "Valid values for var: logging_level are (OFF, INFO, ERROR)."
  }
}

variable "endpoint_type" {
  type        = string
  description = "The type of the endpoint. One of - PUBLIC, PRIVATE, REGIONAL"
  default     = "EDGE"

  validation {
    condition     = contains(["EDGE", "REGIONAL", "PRIVATE"], var.endpoint_type)
    error_message = "Valid values for var: endpoint_type are (EDGE, REGIONAL, PRIVATE)."
  }
}