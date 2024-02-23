terraform {
  required_version = "~> 1.3"

  required_providers {
    postgresql = {
      version = "~> 1.21"
      source  = "cyrilgdn/postgresql"
    }

  }
}


provider "postgresql" {
  host            = var.host
  port            = var.port
  database        = var.database
  superuser       = var.superuser
  username        = var.username
  password        = var.password
  sslmode         = var.sslmode
  connect_timeout = var.connect_timeout
}

resource "postgresql_database" "pg_db" {
  for_each = var.postgresql_database
  name     = each.value.db_name
  //owner             = each.value.db_owner
  template          = each.value.template
  lc_collate        = each.value.lc_collate
  connection_limit  = each.value.connection_limit
  allow_connections = each.value.allow_connections

}

resource "postgresql_default_privileges" "default_privileges" {
  for_each    = var.postgresql_default_privileges
  role        = each.value.role
  database    = each.value.database
  schema      = each.value.schema
  owner       = each.value.owner
  object_type = each.value.object_type
  privileges  = each.value.privileges

  depends_on = [
  postgresql_database.pg_db]
}

resource "postgresql_schema" "pg_schema" {
  for_each      = var.postgresql_schema
  name          = each.value.schema_name
  owner         = each.value.schema_owner
  database      = each.value.database
  if_not_exists = each.value.if_not_exists
  drop_cascade  = each.value.drop_cascade

  dynamic "policy" {
    for_each = each.value.policy
    content {
      usage = lookup(policy.value, "usage", null)
      role  = lookup(policy.value, "role", null)
    }
  }
}

##################################################################
## Postgresql User 
##################################################################

resource "null_resource" "trigger_password_generation" {
  count = local.generate_passwords ? 1 : 0

  provisioner "local-exec" {
    command = "echo Passwords will be generated."
  }
}

resource "random_password" "pg_user_passwords" {
  count = local.generate_passwords ? length(var.pg_users) : 0

  length           = 16
  special          = true
  override_special = "-_?$*"

  depends_on = [null_resource.trigger_password_generation]

  lifecycle {
    create_before_destroy = true
  }
}

resource "postgresql_role" "pg_users" {
  for_each = local.generate_passwords ? { for idx, user in var.pg_users : idx => user } : {}

  name     = each.value.name
  login    = each.value.login
  password = local.generate_passwords ? random_password.pg_user_passwords[each.key].result : null
}

#### SSM parameter
resource "aws_ssm_parameter" "pg_user_parameters" {
  count = local.generate_passwords ? length(var.pg_users) : 0

  name  = "/${var.parameter_name_prefix}/pg_db_user_${count.index + 1}"
  type  = "SecureString"
  value = random_password.pg_user_passwords[count.index].result
}

resource "aws_ssm_parameter" "pg_user_password_parameters" {
  count = local.generate_passwords ? length(var.pg_users) : 0

  name  = "/${var.parameter_name_prefix}/pg_db_user_password_${count.index + 1}"
  type  = "SecureString"
  value = var.pg_users[count.index].name

}
