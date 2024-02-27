#############################################################################
## default
#############################################################################
terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.24.0"
    }
  }

  backend "s3" {}

}


provider "aws" {
  region = var.region
}

#############################################################################
## data lookup
#############################################################################
data "aws_caller_identity" "this" {}

data "aws_ssm_parameter" "karpenter_role" {
  name = "/${var.namespace}/${var.environment}/karpenter_role"
}

#############################################################################
## update aws-auth configmap
#############################################################################
module "eks_auth" {
  source           = "../../eks-auth"
  eks_cluster_name = "${var.namespace}-${var.environment}-eks-cluster"
  add_extra_iam_roles = [
    {
      groups    = ["system:bootstrappers", "system:nodes"]
      role_arn  = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/${data.aws_ssm_parameter.karpenter_role.value}"
      user_name = "system:node:{{EC2PrivateDNSName}}"
    }
  ]

}