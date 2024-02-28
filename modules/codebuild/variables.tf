variable "name" {
  description = "CodeBuild Project Name"
  default     = "my-codebuild-project"
  type        = string
}

variable "description" {
  type        = string
  default     = "my-codebuild-project"
  description = "Description of Codebuild Project"
}

variable "concurrent_build_limit" {
  type        = number
  default     = 1
  description = "Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit."
}

variable "service_role" {
  type        = string
  default     = ""
  description = "CodeBuild IAM Service Role"
}

variable "badge_enabled" {
  type        = bool
  default     = false
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled"
}

variable "build_timeout" {
  default     = 60
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}

variable "queued_timeout" {
  default     = 8
  description = "Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours."
}

variable "encryption_key" {
  type        = string
  default     = ""
  description = "AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project build output artifacts"
}

variable "source_version" {
  type        = string
  default     = ""
  description = "A version of the build input to be built for this project. If not specified, the latest version is used."
}

################################################################################
## codebuild source
################################################################################

variable "source_type" {
  type        = string
  default     = "GITHUB"
  description = "The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET or S3"
}

variable "buildspec" {
  type        = string
  default     = ""
  description = "Optional buildspec declaration to use for building the project"
}

variable "source_location" {
  type        = string
  default     = ""
  description = "The location of the source code from git or s3"
}

variable "git_clone_depth" {
  type        = number
  default     = 0
  description = "Truncate git history to this many commits. Use 0 for Full"
}

variable "report_build_status" {
  type        = bool
  default     = false
  description = "Set to true to report the status of a build's start and finish to your source provider. This option is only valid when the source_type is BITBUCKET or GITHUB"
}

variable "fetch_submodules" {
  type        = bool
  default     = false
  description = "If set to true, fetches Git submodules for the AWS CodeBuild build project."
}

################################################################################
## artifact
################################################################################
variable "artifact_type" {
  type        = string
  default     = "NO_ARTIFACTS"
  description = "The build output artifact's type. Valid values for this parameter are: CODEPIPELINE, NO_ARTIFACTS or S3"
}

variable "artifact_location" {
  type        = string
  default     = ""
  description = "Location of artifact. Applies only for artifact of type S3"
}

################################################################################
## Cache
################################################################################
variable "cache_type" {
  type        = string
  default     = "NO_CACHE"
  description = "The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO_CACHE, LOCAL, and S3.  Defaults to NO_CACHE.  If cache_type is S3, it will create an S3 bucket for storing codebuild cache inside"
}

variable "cache_mode" {
  type        = list(string)
  default     = []
  description = "Required when cache type is LOCAL. Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: LOCAL_SOURCE_CACHE, LOCAL_DOCKER_LAYER_CACHE, LOCAL_CUSTOM_CACHE"
}

variable "cache_location" {
  type        = string
  default     = ""
  description = "Required when cache type is S3. Location where the AWS CodeBuild project stores cached resources. For type S3, the value must be a valid S3 bucket name/prefix."
}

################################################################################
## VPC Config
################################################################################
variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security group IDs to assign to running builds."
}

variable "subnets" {
  type        = list(string)
  default     = []
  description = "Subnet IDs within which to run builds."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "ID of the VPC within which to run builds."
}

################################################################################
## environment
################################################################################
variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
      type  = string
    }
  ))

  default = []

  description = "A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER_STORE', or 'SECRETS_MANAGER'"
}

variable "build_image" {
  type        = string
  default     = "aws/codebuild/standard:2.0"
  description = "Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
}

variable "build_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The type of build environment, e.g. LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER, WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER, LINUX_LAMBDA_CONTAINER, ARM_LAMBDA_CONTAINER"
}


variable "build_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Instance type of the build instance e.g. UILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE"
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

################################################################################
## Log Config
################################################################################
variable "cloudwatch_log_status" {
  type        = string
  default     = "ENABLED"
  description = "Current status of logs in CloudWatch Logs for a build project. Valid values: ENABLED, DISABLED. Defaults to ENABLED"
}

variable "cloudwatch_log_group_name" {
  type        = string
  default     = "codebuild-log-group"
  description = "Group name of the logs in CloudWatch Logs"
}

variable "cloudwatch_log_stream_name" {
  type        = string
  default     = "log-stream"
  description = "Stream name of the logs in CloudWatch Logs."
}

variable "s3_log_status" {
  type        = string
  default     = "DISABLED"
  description = "Current status of logs in S3 Logs for a build project. Valid values: ENABLED, DISABLED. Defaults to ENABLED"
}

variable "s3_log_location" {
  type        = string
  default     = ""
  description = "Name of the S3 bucket and the path prefix for S3 logs. Must be set if status is ENABLED, otherwise it must be empty"
}

################################################################################
## tags
################################################################################
variable "tags" {
  type        = map(string)
  description = "Tags to assign the security groups."
}

###############################################################################
## Codebuild Authnetication
###############################################################################
variable "enable_codebuild_authentication" {
  type        = bool
  default     = false
  description = "Enable codebuild authentication"
}

variable "source_credential_auth_type" {
  type        = string
  default     = "PERSONAL_ACCESS_TOKEN"
  description = "The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository. value can be PERSONAL_ACCESS_TOKEN or BASIC_AUTH"
}

variable "source_credential_server_type" {
  type        = string
  default     = "GITHUB"
  description = "The source provider used for this project."
}

variable "source_credential_token" {
  type        = string
  default     = ""
  description = "For GitHub or GitHub Enterprise, this is the personal access token. For Bitbucket, this is the app password."
}

variable "source_credential_user_name" {
  type        = string
  default     = ""
  description = "The Bitbucket username when the authType is BASIC_AUTH. This parameter is not valid for other types of source providers or connections."
}