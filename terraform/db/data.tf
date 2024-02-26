################################################################################
## account
################################################################################
data "aws_partition" "this" {}

data "aws_caller_identity" "current" {}

################################################################################
## network
################################################################################
# data "aws_ssm_parameter" "terraform_state_bucket" {
#   name = "/${var.namespace}/${var.environment}/terraform-state-bucket"
# }

# data "terraform_remote_state" "network" {
#   backend = "s3"

#   config = {
#     region = var.region
#     key    = "network/terraform.tfstate"
#     bucket = data.aws_ssm_parameter.terraform_state_bucket.value
#   }

# }

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