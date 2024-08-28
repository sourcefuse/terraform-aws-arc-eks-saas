################################################################################
## data lookups
################################################################################
data "aws_caller_identity" "this" {}

data "aws_ssm_parameter" "github_token" {
  name = "/github_token"
}

data "aws_ssm_parameter" "github_user" {
  name = "/github_user"
}

data "aws_ssm_parameter" "terraform_state_bucket" {
  name = "/${var.namespace}/${var.environment}/terraform-state-bucket"
}

data "aws_ssm_parameter" "codebuild_role" {
  name = "/${var.namespace}/${var.environment}/codebuild_role"
}

data "aws_ssm_parameter" "karpenter_role" {
  name = "/${var.namespace}/${var.environment}/karpenter_role"
}

################################################################################
## network data
################################################################################

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Type"

    values = ["private"]
  }
  filter {
    name = "tag:Environment"

    values = ["${var.environment}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Type"

    values = ["public"]
  }
  filter {
    name = "tag:Environment"

    values = ["${var.environment}"]
  }
}

data "aws_security_groups" "codebuild_db_access" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-codebuild-db-access"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}
################################################################################
## tenant codebuild iam policy
################################################################################
data "aws_iam_policy_document" "tenant_codebuild_policy" {

  statement {
    sid    = "TenantCodeBuildPolicy"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "codebuild:BatchPutCodeCoverages",
      "codebuild:BatchPutTestCases",
      "codebuild:CreateReport",
      "codebuild:CreateReportGroup",
      "codebuild:UpdateReport",
      "codecommit:*",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission",
      "kms:*",
      "s3:*",
      "ssm:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {

  statement {
    sid    = "AssumeRolePolicy"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/*"]
  }
}