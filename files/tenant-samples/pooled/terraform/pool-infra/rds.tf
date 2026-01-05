################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Tenant = "pooled"
    Tier = var.tenant_tier
  }

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


  environment = "${var.environment}-${var.tenant_tier}"
  namespace   = var.namespace
  region      = var.region
  vpc_id      = data.aws_vpc.vpc.id

  aurora_cluster_enabled                    = var.aurora_cluster_enabled
  aurora_cluster_name                       = "aurora"
  enhanced_monitoring_name                  = "${var.namespace}-${var.environment}-${var.tenant_tier}-enhanced-monitoring"
  aurora_db_admin_username                  = "dbpooleduser"
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
  aurora_cluster_size                       = var.aurora_cluster_size
  aurora_subnets                            = data.aws_subnets.private.ids
  aurora_allowed_cidr_blocks                = [data.aws_vpc.vpc.cidr_block]
  aurora_serverlessv2_scaling_configuration = var.aurora_serverlessv2_scaling_configuration
  performance_insights_enabled              = var.performance_insights_enabled
  performance_insights_retention_period     = var.performance_insights_retention_period
  iam_database_authentication_enabled       = var.iam_database_authentication_enabled

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
##################################################################################
## RDS Operations
##################################################################################
provider "postgresql" {
  host      = module.aurora.aurora_endpoint
  port      = var.aurora_db_port
  database  = var.aurora_db_name
  username  = "dbpooleduser"
  password  = module.db_password.result
  sslmode   = "require"
  superuser = false
}

resource "postgresql_database" "feature_db" {
  name              = var.featuredbdatabase
  allow_connections = true
  depends_on        = [module.aurora]
}
resource "postgresql_database" "authentication_db" {
  name              = var.authenticationdbdatabase
  allow_connections = true
  depends_on        = [module.aurora]
}
resource "postgresql_database" "notification_db" {
  name              = var.notificationdbdatabase
  allow_connections = true
  depends_on        = [module.aurora]
}
resource "postgresql_database" "video_confrencing_db" {
  name              = var.videoconfrencingdbdatabase
  allow_connections = true
  depends_on        = [module.aurora]
}
########################################################################
## Store DB Configs in Parameter Store
########################################################################
module "db_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_user"
      value       = "dbpooleduser"
      type        = "String"
      overwrite   = "true"
      description = "Database User Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_password"
      value       = module.db_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Password"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_host"
      value       = module.aurora.aurora_endpoint
      type        = "String"
      overwrite   = "true"
      description = "Database Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_port"
      value       = var.aurora_db_port
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Port"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_database"
      value       = var.aurora_db_name
      type        = "SecureString"
      overwrite   = "true"
      description = "Default Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_schema"
      value       = "main"
      type        = "SecureString"
      overwrite   = "true"
      description = "Default Database Schema"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/featuredbdatabase"
      value       = var.featuredbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Feature Toggle Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/authenticationdbdatabase"
      value       = var.authenticationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Authentication Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/notificationdbdatabase"
      value       = var.notificationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Notification Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/videoconfrencingdbdatabase"
      value       = var.videoconfrencingdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Video Confrencing Database Name"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.aurora, module.db_password]
}
