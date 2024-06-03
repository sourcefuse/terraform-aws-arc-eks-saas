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


  environment = "${var.environment}-pooled"
  namespace   = var.namespace
  region      = var.region
  vpc_id      = data.aws_vpc.vpc.id

  aurora_cluster_enabled                    = var.aurora_cluster_enabled
  aurora_cluster_name                       = "aurora"
  enhanced_monitoring_name                  = "${var.namespace}-${var.environment}-pooled-enhanced-monitoring"
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

resource "postgresql_database" "audit_db" {
  name              = var.auditdbdatabase
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
resource "postgresql_database" "user_db" {
  name              = var.userdbdatabase
  allow_connections = true
  depends_on        = [module.aurora]
}
resource "postgresql_database" "product_db" {
  name              = var.productdbdatabase
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
      name        = "/${var.namespace}/${var.environment}/pooled/db_user"
      value       = "dbpooleduser"
      type        = "String"
      overwrite   = "true"
      description = "Database User Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/db_password"
      value       = module.db_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Password"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/db_host"
      value       = module.aurora.aurora_endpoint
      type        = "String"
      overwrite   = "true"
      description = "Database Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/db_port"
      value       = var.aurora_db_port
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Port"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/db_database"
      value       = var.aurora_db_name
      type        = "SecureString"
      overwrite   = "true"
      description = "Default Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/db_schema"
      value       = "main"
      type        = "SecureString"
      overwrite   = "true"
      description = "Default Database Schema"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/auditdbdatabase"
      value       = var.auditdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Audit Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/authenticationdbdatabase"
      value       = var.authenticationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Authentication Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/notificationdbdatabase"
      value       = var.notificationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Notification Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/schedulerdbdatabase"
      value       = var.schedulerdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Scheduler Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/userdbdatabase"
      value       = var.userdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "User Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/videodbdatabase"
      value       = var.videodbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "User Management Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/productdbdatabase"
      value       = var.productdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Product Database Name"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.aurora, module.db_password]
}
