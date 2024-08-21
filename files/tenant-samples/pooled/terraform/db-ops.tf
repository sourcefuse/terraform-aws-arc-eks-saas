provider "postgresql" {
  host      = data.aws_ssm_parameter.db_host.value
  port      = data.aws_ssm_parameter.db_port.value
  database  = "auroradb"
  username  = data.aws_ssm_parameter.db_user.value
  password  = data.aws_ssm_parameter.db_password.value
  sslmode   = "require"
  superuser = false
}

resource "random_id" "uuid" {
  byte_length = 16
}

#######################################################################
## pooled tenant db user
#######################################################################
module "tenant_db_password" {
  source           = "../modules/random-password"
  length           = 16
  is_special       = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "postgresql_role" "db_user" {
  name     = var.tenant
  login    = true
  password = module.tenant_db_password.result
}

module "db_ssm_parameters" {
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_user"
      value       = "${var.tenant}"
      type        = "String"
      overwrite   = "true"
      description = "Database User Name"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/db_password"
      value       = module.tenant_db_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Database Password"
    }
  ]
  tags = module.tags.tags
}