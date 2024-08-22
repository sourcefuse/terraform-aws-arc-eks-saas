################################################################################
## db
################################################################################
module "db_password" {
  source           = "../modules/random-password"
  length           = 16
  is_special       = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


module "rds_postgres" {
  source      = "sourcefuse/arc-db/aws"
  version     = "3.1.5"
  
  environment = "${var.environment}-${var.tenant_tier}-${var.tenant}"
  namespace   = var.namespace
  region      = var.region
  vpc_id      = data.aws_vpc.vpc.id

  account_id                              = data.aws_caller_identity.current.id
  rds_instance_enabled                     = var.rds_instance_enabled
  rds_instance_name                        = var.rds_instance_name
  enhanced_monitoring_name                 = "${var.namespace}-${var.environment}-${var.tenant}-enhanced-monitoring"
  rds_instance_database_name               = var.rds_instance_database_name
  rds_instance_database_user               = var.tenant
  rds_instance_database_password           = module.db_password.result
  rds_instance_database_port               = var.rds_instance_database_port
  rds_instance_engine                      = var.rds_instance_engine
  rds_instance_engine_version              = var.rds_instance_engine_version
  rds_instance_major_engine_version        = var.rds_instance_major_engine_version
  rds_instance_db_parameter_group          = var.rds_instance_db_parameter_group
  rds_instance_db_parameter                = var.rds_instance_db_parameter
  rds_instance_db_options                  = var.rds_instance_db_options
  rds_enable_custom_option_group           = var.rds_enable_custom_option_group
  rds_instance_ca_cert_identifier          = var.rds_instance_ca_cert_identifier
  rds_instance_publicly_accessible         = var.rds_instance_publicly_accessible
  rds_instance_multi_az                    = var.rds_instance_multi_az
  rds_instance_storage_type                = var.rds_instance_storage_type
  rds_instance_instance_class              = var.rds_instance_instance_class
  rds_instance_allocated_storage           = var.rds_instance_allocated_storage
  rds_instance_storage_encrypted           = var.rds_instance_storage_encrypted
  rds_instance_snapshot_identifier         = var.rds_instance_snapshot_identifier
  rds_instance_auto_minor_version_upgrade  = var.rds_instance_auto_minor_version_upgrade
  rds_instance_allow_major_version_upgrade = var.rds_instance_allow_major_version_upgrade
  rds_instance_apply_immediately           = var.rds_instance_apply_immediately
  rds_instance_maintenance_window          = var.rds_instance_maintenance_window
  rds_instance_skip_final_snapshot         = var.rds_instance_skip_final_snapshot
  rds_instance_copy_tags_to_snapshot       = var.rds_instance_copy_tags_to_snapshot
  rds_instance_backup_retention_period     = var.rds_instance_backup_retention_period
  rds_instance_backup_window               = var.rds_instance_backup_window
  rds_instance_allowed_cidr_blocks         = [data.aws_vpc.vpc.cidr_block]
  rds_instance_subnet_ids                  = data.aws_subnets.private.ids
  additional_ingress_rules_rds             = var.additional_inbound_rules

  tags = merge(
    module.tags.tags
  )
}


#######################################################################
## Security Group ingress rules
#######################################################################


resource "aws_security_group_rule" "additional_inbound_rules" {

  depends_on = [module.rds_postgres]

  count             = length(var.additional_inbound_rules)
  security_group_id = data.aws_security_groups.rds_postgres.ids[0]
  description       = var.additional_inbound_rules[count.index].description
  type = var.additional_inbound_rules[count.index].type
  from_port         = var.additional_inbound_rules[count.index].from_port
  to_port           = var.additional_inbound_rules[count.index].to_port
  protocol          = var.additional_inbound_rules[count.index].protocol
  cidr_blocks       = var.additional_inbound_rules[count.index].cidr_blocks
}
##################################################################################
## RDS Operations
##################################################################################
provider "postgresql" {
  host      = trim("${module.rds_postgres.rds_instance_endpoint}", ":5432")
  port      = var.rds_instance_database_port
  database  = var.rds_instance_database_name
  username  = var.tenant
  password  = module.db_password.result
  sslmode   = "require"
  superuser = false
}

resource "postgresql_database" "feature_db" {
  name              = var.featuredbdatabase
  allow_connections = true
  depends_on        = [module.rds_postgres]
}
resource "postgresql_database" "authentication_db" {
  name              = var.authenticationdbdatabase
  allow_connections = true
  depends_on        = [module.rds_postgres]
}
resource "postgresql_database" "notification_db" {
  name              = var.notificationdbdatabase
  allow_connections = true
  depends_on        = [module.rds_postgres]
}
resource "postgresql_database" "video_confrencing_db" {
  name              = var.videoconfrencingdbdatabase
  allow_connections = true
  depends_on        = [module.rds_postgres]
}

########################################################################
## Store DB Configs in Parameter Store
########################################################################
module "db_ssm_parameters" {
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_user"
      value       = var.tenant
      type        = "String"
      overwrite   = "true"
      description = "Database User Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_password"
      value       = module.db_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Password"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_host"
      value       = trim("${module.rds_postgres.rds_instance_endpoint}", ":5432")
      type        = "String"
      overwrite   = "true"
      description = "Database Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_port"
      value       = var.rds_instance_database_port
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Port"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_database"
      value       = var.rds_instance_database_name
      type        = "SecureString"
      overwrite   = "true"
      description = "Default Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_schema"
      value       = "main"
      type        = "SecureString"
      overwrite   = "true"
      description = "Default Database Schema"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_arn"
      value       = module.rds_postgres.rds_instance_arn
      type        = "SecureString"
      overwrite   = "true"
      description = "Database ARN"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/featuredbdatabase"
      value       = var.featuredbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Feature Toggle Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/authenticationdbdatabase"
      value       = var.authenticationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Authentication Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/notificationdbdatabase"
      value       = var.notificationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Notification Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/videoconfrencingdbdatabase"
      value       = var.videoconfrencingdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Video Confrencing Database Name"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.rds_postgres, module.db_password]
}
