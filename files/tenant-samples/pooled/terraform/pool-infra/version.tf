terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }

    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.12.0"
    }
  }

  backend "s3" {}
}
