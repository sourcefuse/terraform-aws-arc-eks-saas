################################################################################
## account
################################################################################
data "aws_caller_identity" "this" {}

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
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Type"

    values = ["public"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}