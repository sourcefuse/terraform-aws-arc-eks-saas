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

# locals {
#   postgresql_users = { for e in var.postgresql_users : e.name => merge(var.postgresql_default_users, e) }
# }

# resource "random_password" "password" {
#   for_each = local.og_random_passwords
#   length   = each.value.length
#   special  = each.value.special
# }

# resource "postgresql_role" "pg_role" {
#   for_each = local.postgresql_users
#   name = each.key 

#   login    = each.value.login
#   password = each.value.password

# }

# resource "random_password" "pg_user_passwords" {
#   count            = length(var.pg_users)
#   length           = 16
#   special          = true
#   override_special = "-_?$*"
# }

# locals {
#   pg_user_roles = {
#     for user in var.pg_users : user.name => {
#       name     = user.name
#       login    = user.login
#       password = user.login ? random_password.pg_user_passwords[user.name].result : null
#     }
#   }
# }

# resource "postgresql_role" "pg_users" {
#   for_each = { for idx, user in var.pg_users : idx => user if user.login }

#   name     = each.value.name
#   login    = each.value.login
#   password = random_password.pg_user_passwords[each.key].result
# }

# resource "postgresql_role" "pg_users" {
#   for_each = local.pg_user_roles

#   name     = each.value.name
#   login    = each.value.login
#   password = each.value.password
# }

locals {
  generate_passwords = length(var.pg_users) > 0 ? true : false
}

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