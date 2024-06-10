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
## db operations
################################################################################
module "postgresql_provider" {
  source    = "../../modules/postgresql"
  host      = data.aws_ssm_parameter.db_host.value
  port      = data.aws_ssm_parameter.db_port.value
  database  = var.aurora_db_name
  username  = data.aws_ssm_parameter.db_user.value
  password  = data.aws_ssm_parameter.db_password.value
  sslmode   = "require"
  superuser = false


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

################################################################################
## store databases name in SSM parameter store
################################################################################
module "db_ops_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
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
  tags = module.tags.tags
}
