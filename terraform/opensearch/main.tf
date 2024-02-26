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

################################################################################
## opensearch password
################################################################################
module "os_password" {
  source           = "../../modules/random-password"
  length           = 16
  is_special       = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

################################################################################
## opensearch
################################################################################
module "opensearch" {
  source  = "sourcefuse/arc-opensearch/aws"
  version = "0.1.8"

  name                       = "${var.namespace}-${var.environment}-opensearch"
  environment                = var.environment
  namespace                  = var.namespace
  admin_username             = var.admin_username
  custom_opensearch_password = module.os_password.result

  ## network / security
  vpc_id             = data.aws_vpc.vpc.id
  subnet_ids         = local.public_subnet_ids
  availability_zones = local.private_subnet_azs

  iam_actions              = var.os_iam_actions
  additional_iam_role_arns = var.os_additional_iam_role_arns

  ## auth
  create_iam_service_linked_role = var.create_iam_service_linked_role

  ## instance setup
  elasticsearch_version = var.elasticsearch_version
  instance_count        = var.instance_count
  instance_type         = var.instance_type
  ebs_volume_size       = var.ebs_volume_size

  ## Advance options
  advanced_security_options_enabled                        = var.advanced_security_options_enabled
  advanced_options                                         = var.advanced_options
  advanced_security_options_internal_user_database_enabled = var.advanced_security_options_internal_user_database_enabled
  node_to_node_encryption_enabled                          = var.node_to_node_encryption_enabled
  zone_awareness_enabled                                   = var.zone_awareness_enabled
  encrypt_at_rest_enabled                                  = var.encrypt_at_rest_enabled

  tags = module.tags.tags
}

################################################################################
## security group
################################################################################
resource "aws_security_group_rule" "additional" {
  for_each = { for x in local.additional_sg_rules : "${x.name}_${x.protocol}_${x.from_port}_${x.to_port}" => x }

  security_group_id = module.opensearch.security_group_id
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  type              = each.value.type
}

# ################################################################################
# ## storing opensearch username and password in SSM paramter store
# ################################################################################
# module "os_ssm_parameters" {
#   source = "../../modules/ssm-parameter"
#   ssm_parameters = [
#     {
#       name        = "/${var.namespace}/${var.environment}/os_user"
#       value       = var.admin_username
#       type        = "SecureString"
#       overwrite   = "true"
#       description = "OpenSearch User Name"
#     },
#     {
#       name        = "/${var.namespace}/${var.environment}/os_password"
#       value       = module.os_password.result
#       type        = "SecureString"
#       overwrite   = "true"
#       description = "OpenSearch Password"
#     }
#   ]
#   tags = module.tags.tags
# }