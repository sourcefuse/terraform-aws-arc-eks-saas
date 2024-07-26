##############################################################
## data lookup
##############################################################
data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "codebuild_policy" {

  statement {
    sid    = "CodeBuildPolicy"
    effect = "Allow"
    actions = [
      "rds:*",
      "elasticache:*",
      "s3:*",
      "es:*",
      "ec2:*",
      "eks:*",
      "cognito-idp:*",
      "iam:*",
      "ssm:*",
      "dynamodb:*",
      "aps:*",
      "kms:*",
      "logs:*",
      "lambda:*",
      "glue:*",
      "SNS:*",
      "cur:*",
      "budgets:*",
      "route53:*",
      "elasticloadbalancing:DescribeLoadBalancers",
      "codecommit:*",
      "synthetics:*",
      "cloudwatch:*",
      "backup:*",
      "backup-storage:MountCapsule",
      "events:*"
    ]
    resources = ["*"]
  }
}