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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    postgresql = {
      source  = "ricochet1k/postgresql"
      version = "1.20.2"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "= 2.2.0"
    }

  }

  backend "s3" {}
}