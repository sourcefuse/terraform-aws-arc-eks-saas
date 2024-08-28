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

###############################################################################
## github
################################################################################
variable "is_organization" {
  type        = bool
  description = "Enable or Disable based on if github repository is part of organization or not "
  default     = false
}

variable "organization_name" {
  type        = string
  description = "Github organization Name"
  default     = "sourcefuse"
}

################################################################################
## codebuild
################################################################################
variable "create_premium_codebuild" {
  type        = bool
  description = "Enable or Disable to create premium codebuild project"
  default     = true
}

variable "create_standard_codebuild" {
  type        = bool
  description = "Enable or Disable to create standard codebuild project"
  default     = true
}


variable "create_basic_codebuild" {
  type        = bool
  description = "Enable or Disable to create basic codebuild project"
  default     = true
}

variable "create_premium_offboard_codebuild" {
  type        = bool
  description = "Enable or Disable to create premium offboarding codebuild project"
  default     = true
}

variable "premium_offboard_buildspec" {
  type        = string
  default     = ""
  description = "Optional buildspec declaration to use for building the project"
}

variable "concurrent_build_limit" {
  type        = number
  default     = 1
  description = "Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit."
}

variable "build_timeout" {
  type        = number
  default     = 120
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}

variable "queued_timeout" {
  type        = number
  default     = 8
  description = "Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours."
}

variable "premium_source_version" {
  type        = string
  default     = ""
  description = "A version of the Premium build input to be built for this project. If not specified, the latest version is used."
}

variable "standard_source_version" {
  type        = string
  default     = ""
  description = "A version of the Standard build input to be built for this project. If not specified, the latest version is used."
}

variable "basic_source_version" {
  type        = string
  default     = ""
  description = "A version of the Basic build input to be built for this project. If not specified, the latest version is used."
}

variable "source_type" {
  type        = string
  default     = "GITHUB"
  description = "The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET or S3"
}

variable "premium_buildspec" {
  type        = string
  default     = ""
  description = "Optional buildspec declaration to use for building the project"
}

variable "standard_buildspec" {
  type        = string
  default     = ""
  description = "Optional buildspec declaration to use for building the project"
}

variable "basic_buildspec" {
  type        = string
  default     = ""
  description = "Optional buildspec declaration to use for building the project"
}

variable "premium_source_location" {
  type        = string
  default     = ""
  description = "The location of the source code from git or s3"
}

variable "standard_source_location" {
  type        = string
  default     = ""
  description = "The location of the source code from git or s3"
}

variable "basic_source_location" {
  type        = string
  default     = ""
  description = "The location of the source code from git or s3"
}

variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Instance type of the build instance e.g. UILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/standard:7.0"
  description = "Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
}

variable "build_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The type of build environment, e.g. LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER, WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER, LINUX_LAMBDA_CONTAINER, ARM_LAMBDA_CONTAINER"
}

variable "build_image_pull_credentials_type" {
  type        = string
  default     = "CODEBUILD"
  description = "Type of credentials AWS CodeBuild uses to pull images in your build.Valid values: CODEBUILD, SERVICE_ROLE. When you use a cross-account or private registry image, you must use SERVICE_ROLE credentials."
}

variable "privileged_mode" {
  type        = bool
  default     = true
  description = "(Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images"
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "Domain name of the control plane"
}

variable "control_plane_host" {
  type        = string
  description = "Host Name of the control plane"
}

variable "premium_cloudwatch_log_group_name" {
  type        = string
  default     = "premium-codebuild-log-group"
  description = "Group name of the logs in CloudWatch Logs"
}

variable "standard_cloudwatch_log_group_name" {
  type        = string
  default     = "standard-codebuild-log-group"
  description = "Group name of the logs in CloudWatch Logs"
}

variable "basic_cloudwatch_log_group_name" {
  type        = string
  default     = "basic-codebuild-log-group"
  description = "Group name of the logs in CloudWatch Logs"
}

variable "cloudwatch_log_stream_name" {
  type        = string
  default     = "log-stream"
  description = "Stream name of the logs in CloudWatch Logs."
}
