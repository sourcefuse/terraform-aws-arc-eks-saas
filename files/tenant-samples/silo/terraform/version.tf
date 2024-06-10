terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.12.0"
    }

    opensearch = {
      source  = "opensearch-project/opensearch"
      version = "2.2.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }

  backend "s3" {}
}