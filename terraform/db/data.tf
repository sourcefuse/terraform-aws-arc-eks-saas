################################################################################
## account
################################################################################
data "aws_partition" "this" {}

data "aws_caller_identity" "current" {}

################################################################################
## network
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

## security
data "aws_security_groups" "aurora" {
  depends_on = [module.aurora]
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-aurora"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}