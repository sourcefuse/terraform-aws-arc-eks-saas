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
  source           = "../../modules/eks-auth"
  eks_cluster_name = "${var.namespace}-${var.environment}-eks-cluster"

  add_extra_iam_roles = concat(local.map_karpenter_iam_role, var.map_additional_iam_roles)
  add_extra_iam_users = var.map_additional_iam_users
}