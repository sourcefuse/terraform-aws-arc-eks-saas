##############################################################################
##Default
##############################################################################
terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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

##############################################################################
##Tags
##############################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

##############################################################################
## Opensearch Operations
##############################################################################
provider "opensearch" {
  url               = "https://${data.aws_ssm_parameter.opensearch_domain.value}"
  username          = data.aws_ssm_parameter.opensearch_username.value
  password          = data.aws_ssm_parameter.opensearch_password.value
  sign_aws_requests = false
}

resource "opensearch_roles_mapping" "mapper" {
  role_name     = "all_access"
  description   = "Mapping AWS IAM roles to ES role"
  backend_roles = concat(var.backend_roles, local.fluentbit_role)
  #   backend_roles = [
  #     "${data.aws_ssm_parameter.fluentbit_role.value}"
  #   ]

  users = ["os_admin"]
}