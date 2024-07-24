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

############################################################################
## API Gateway
############################################################################
variable "logging_level" {
  type        = string
  description = "The logging level of the API. One of - OFF, INFO, ERROR"
  default     = "OFF"

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