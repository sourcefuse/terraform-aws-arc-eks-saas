#######################################################################################
## Codebuild
#######################################################################################
resource "aws_codebuild_project" "codebuild_project" {
  name                   = var.name
  description            = var.description
  concurrent_build_limit = var.concurrent_build_limit
  service_role           = var.service_role
  badge_enabled          = var.badge_enabled
  build_timeout          = var.build_timeout
  queued_timeout         = var.queued_timeout
  encryption_key         = var.encryption_key
  source_version         = var.source_version

  source {
    type                = var.source_type
    buildspec           = var.buildspec
    location            = var.source_location
    git_clone_depth     = var.git_clone_depth != null ? var.git_clone_depth : null
    report_build_status = var.report_build_status

    git_submodules_config {

      fetch_submodules = var.fetch_submodules

    }

  }

  artifacts {
    type     = var.artifact_type
    location = var.artifact_location
  }

  cache {
    type     = var.cache_type
    location = var.cache_location
    modes    = var.cache_mode
  }

  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.subnets

    security_group_ids = var.security_group_ids
  }

  environment {
    compute_type                = var.build_compute_type
    image                       = var.build_image
    type                        = var.build_type
    image_pull_credentials_type = var.build_image_pull_credentials_type
    privileged_mode             = var.privileged_mode

    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value.name
        value = environment_variable.value.value
        type  = environment_variable.value.type
      }
    }
  }
  logs_config {
    cloudwatch_logs {
      status      = var.cloudwatch_log_status
      group_name  = var.cloudwatch_log_group_name
      stream_name = var.cloudwatch_log_stream_name
    }

    s3_logs {
      status   = var.s3_log_status
      location = var.s3_log_location
    }
  }

  tags = var.tags
}

#############################################################################
## codebuild auth
#############################################################################
resource "aws_codebuild_source_credential" "authorization" {
  count       = var.enable_codebuild_authentication ? 1 : 0
  auth_type   = var.source_credential_auth_type
  server_type = var.source_credential_server_type
  token       = var.source_credential_token
  user_name   = var.source_credential_user_name
}