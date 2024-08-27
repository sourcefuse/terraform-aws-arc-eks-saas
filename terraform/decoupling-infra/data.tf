################################################################################
## account
################################################################################
data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "karpenter_role" {
  name = "/${var.namespace}/${var.environment}/karpenter_role"
}

data "aws_ssm_parameter" "codebuild_role" {
  name = "/${var.namespace}/${var.environment}/codebuild_role"
}

data "aws_ssm_parameter" "api_gw_url" {
  name       = "/${var.namespace}/${var.environment}/api_gw_arn"
  depends_on = [module.api_gw_ssm_parameters]
}

data "aws_ssm_parameter" "orchestrator_ecr_image" {
  name = "/${var.namespace}/${var.environment}/orchestration-ecr-image-uri"
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
########################################################################
## network lookup
########################################################################
data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
  filter {
    name   = "tag:Project"
    values = ["${var.namespace}"]
  }
}

