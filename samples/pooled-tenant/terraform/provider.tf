################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "2.2.0"
    }

  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.EKScluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.EKScluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.EKScluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.EKScluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.EKScluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.EKScluster.token
  }
}
################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Tenant    = var.tenant
    Tenant_ID = var.tenant_id
  }

}