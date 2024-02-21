################################################################
## Default
################################################################
variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
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

################################################################
## Pipeline
################################################################
variable "github_connection_pipeline" {
  description = "code star pipeline connect to the github repo"
  type        = string
}

variable "github_FullRepositoryId" {
  description = "role name of the code pipeline"
  type        = string
}

variable "github_BranchName" {
  description = "Github Branch Name"
  type        = string
  default     = "main"
}
