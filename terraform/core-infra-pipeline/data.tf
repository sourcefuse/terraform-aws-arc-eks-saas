data "aws_codestarconnections_connection" "existing_github_connection" {
  name = var.github_connection_pipeline
}

data "aws_ssm_parameter" "artifact_bucket" {
  name = "/${var.namespace}/${var.environment}/artifact-bucket"
}

data "aws_iam_policy_document" "resource_full_access" {

  statement {
    sid    = "FullAccess"
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = ["*"]
  }
}
