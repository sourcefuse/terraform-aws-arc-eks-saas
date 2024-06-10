################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

################################################################################
## db
################################################################################
module "db_password" {
  source           = "../../modules/random-password"
  length           = 16
  is_special       = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "aurora" {
  source  = "sourcefuse/arc-db/aws"
  version = "2.0.3"


  environment = var.environment
  namespace   = var.namespace
  region      = var.region
  vpc_id      = data.aws_vpc.vpc.id

  aurora_cluster_enabled                    = var.aurora_cluster_enabled
  aurora_cluster_name                       = "aurora"
  enhanced_monitoring_name                  = "${var.namespace}-${var.environment}-enhanced-monitoring"
  aurora_db_admin_username                  = var.aurora_db_admin_username
  aurora_db_admin_password                  = module.db_password.result
  aurora_db_name                            = var.aurora_db_name
  aurora_db_port                            = var.aurora_db_port
  aurora_cluster_family                     = var.aurora_cluster_family
  aurora_engine                             = var.aurora_engine
  aurora_engine_mode                        = var.aurora_engine_mode
  aurora_storage_type                       = var.aurora_storage_type
  aurora_engine_version                     = var.aurora_engine_version
  aurora_allow_major_version_upgrade        = var.aurora_allow_major_version_upgrade
  aurora_auto_minor_version_upgrade         = var.aurora_auto_minor_version_upgrade
  aurora_instance_type                      = var.aurora_instance_type
  aurora_subnets                            = data.aws_subnets.private.ids
  aurora_allowed_cidr_blocks                = [data.aws_vpc.vpc.cidr_block]
  aurora_serverlessv2_scaling_configuration = var.aurora_serverlessv2_scaling_configuration
  performance_insights_enabled              = var.performance_insights_enabled
  performance_insights_retention_period     = var.performance_insights_retention_period
  iam_database_authentication_enabled       = var.iam_database_authentication_enabled
  aurora_cluster_size                       = var.aurora_cluster_size
  tags = merge(
    module.tags.tags
  )
}

#######################################################################
## Security Group ingress rules
#######################################################################


resource "aws_security_group_rule" "additional_inbound_rules" {

  depends_on = [module.aurora]

  count             = length(var.additional_inbound_rules)
  security_group_id = data.aws_security_groups.aurora.ids[0]
  description       = var.additional_inbound_rules[count.index].description
  from_port         = var.additional_inbound_rules[count.index].from_port
  to_port           = var.additional_inbound_rules[count.index].to_port
  protocol          = var.additional_inbound_rules[count.index].protocol
  cidr_blocks       = var.additional_inbound_rules[count.index].cidr_blocks
  type              = "ingress"

}

########################################################################
## Store DB Configs in Parameter Store
########################################################################
module "db_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/db_user"
      value       = var.aurora_db_admin_username
      type        = "String"
      overwrite   = "true"
      description = "Database User Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/db_password"
      value       = module.db_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Password"
    },
    {
      name        = "/${var.namespace}/${var.environment}/db_host"
      value       = module.aurora.aurora_endpoint
      type        = "String"
      overwrite   = "true"
      description = "Database Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/db_port"
      value       = var.aurora_db_port
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Port"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.aurora, module.db_password]
}


