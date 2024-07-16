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