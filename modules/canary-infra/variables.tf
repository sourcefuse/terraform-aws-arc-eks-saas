variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "vpc_id" {

}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs in which to execute the canary"
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign the resources."
}