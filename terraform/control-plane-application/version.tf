terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

  }

  backend "s3" {}
}