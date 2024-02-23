resource "aws_iam_role" "codebuild_role" {
  name               = "${var.namespace}-${var.environment}-${var.role_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  inline_policy {
    name = "codebuild-policy"

    policy = module.codebuild_iam_policy.json
  }
  tags = module.tags.tags
}
