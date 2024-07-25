data "aws_ssm_parameter" "api_gw_url" {
    name = "/${var.namespace}/${var.environment}/api_gw_arn"
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