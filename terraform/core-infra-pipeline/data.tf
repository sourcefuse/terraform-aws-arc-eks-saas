data "aws_codestarconnections_connection" "existing_github_connection" {
  name = var.github_connection_pipeline
}

data "aws_s3_bucket" "artifact_bucket" {
  filter {
    name   = "tag:type"
    values = ["artifact"]
  }
  filter {
    name   = "tag:environment"
    values = [var.environment]
  }
}