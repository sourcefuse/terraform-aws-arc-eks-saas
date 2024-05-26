###############################################################################
## Canary
###############################################################################
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

variable "tenant_email" {
  type        = string
  description = "tenant Email"
}

variable "tenant_host_domain" {
  type        = string
  description = "tenant Host"
}

variable "runtime_version" {
  description = "Runtime version of the canary. Details: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Library_nodejs_puppeteer.html"
  type        = string
  default     = "syn-nodejs-puppeteer-7.0"
}

variable "take_screenshot" {
  description = "If screenshot should be taken"
  type        = bool
  default     = false
}

variable "api_path" {
  description = "The path for the API call , ex: /path?param=value."
  type        = string
  default     = "/main/home"
}

variable "frequency" {
  description = "The frequency in minutes at which the canary should be run. The minimum is two minutes."
  type        = string
  default     = "6"
}


variable "endpointpath" {
    description = "path - appended to the hostname for full api request"
    type        = string
    default = "/main/home"
}

variable "port" {
    description = "port to target request on"
    type        = string
    default = "80"
}