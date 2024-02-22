terraform {
  required_version = "~> 1.4"

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
  for_each          = var.postgresql_database
  name              = each.value.db_name
  owner             = each.value.db_owner
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