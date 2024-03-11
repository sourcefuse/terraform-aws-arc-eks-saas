#############################################################################
## Data Import
#############################################################################
data "aws_partition" "this" {}

data "aws_caller_identity" "current" {}

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
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Type"

    values = ["public"]
  }
}

data "aws_security_groups" "aurora" {
  depends_on = [module.aurora]
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-pooled-aurora"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

