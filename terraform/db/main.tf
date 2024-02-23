################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

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
  aurora_cluster_name                       = "${var.namespace}-${var.environment}-aurora"
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
      type        = "SecureString"
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
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/db_port"
      value       = var.aurora_db_port
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Port"
    },
    {
      name        = "/${var.namespace}/${var.environment}/auditdbdatabase"
      value       = var.auditdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Audit Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/authenticationdbdatabase"
      value       = var.authenticationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Authentication Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/notificationdbdatabase"
      value       = var.notificationdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Notification Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/subscriptiondbdatabase"
      value       = var.subscriptiondbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Subscription Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/userdbdatabase"
      value       = var.userdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "User Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/paymentdbdatabase"
      value       = var.paymentdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Payment Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/tenantmgmtdbdatabase"
      value       = var.tenantmgmtdbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Management Database Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/featuretoggledbdatabase"
      value       = var.featuretoggledbdatabase
      type        = "SecureString"
      overwrite   = "true"
      description = "Feature Toggle Database Name"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.aurora, module.db_password]
}



##############################################################################
# ## Postgres provider to create DB & store in parameter store
##############################################################################
module "postgresql_provider" {
  source    = "../../modules/postgresql"
  count = 0
  # host      = module.aurora.aurora_endpoint
  # port      = var.aurora_db_port
  # database  = var.aurora_db_name
  # username  = var.aurora_db_admin_username
  # password  = module.db_password.result
  # sslmode   = "require"
  # superuser = false
  postgresql_provider_config = {
     host      = module.aurora.aurora_endpoint
     port      = var.aurora_db_port
     database  = var.aurora_db_name
     username  = var.aurora_db_admin_username
     password  = module.db_password.result
     sslmode   = "require"
     superuser = false
  }

  postgresql_database = {
    "audit_db" = {
      db_name           = var.auditdbdatabase
      allow_connections = true
    },
    "authentication_db" = {
      db_name           = var.authenticationdbdatabase
      allow_connections = true
    },
    "notification_db" = {
      db_name           = var.notificationdbdatabase
      allow_connections = true
    },
    "subscription_db" = {
      db_name           = var.subscriptiondbdatabase
      allow_connections = true
    },
    "user_db" = {
      db_name           = var.userdbdatabase
      allow_connections = true
    },
    "payment_db" = {
      db_name           = var.paymentdbdatabase
      allow_connections = true
    },
    "tenant_mgmt_db" = {
      db_name           = var.tenantmgmtdbdatabase
      allow_connections = true
    },
    "feature_db" = {
      db_name           = var.featuretoggledbdatabase
      allow_connections = true
    }

  }
  postgresql_default_privileges = {}

  pg_users              = []
  parameter_name_prefix = "${var.namespace}/${var.environment}" //To store user name and password for pg_users list
}

