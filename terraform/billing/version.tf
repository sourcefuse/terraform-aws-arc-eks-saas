terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "5.4.0"
    }
    helm = {
      source  = "helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "kubernetes"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    tls = {
      source  = "tls"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }

  backend "s3" {}
}