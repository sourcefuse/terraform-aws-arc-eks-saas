#####################################################################################
## opensearch operations
#####################################################################################
provider "opensearch" {
  url               = "https://${data.aws_ssm_parameter.opensearch_domain.value}"
  username          = data.aws_ssm_parameter.opensearch_username.value
  password          = data.aws_ssm_parameter.opensearch_password.value
  sign_aws_requests = false
}

module "tenant_opensearch_password" {
  source           = "../modules/random-password"
  length           = 16
  is_special       = true
  min_special      = 1
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  override_special = "!_%@"
}

resource "opensearch_user" "tenant_user" {
  for_each    = local.users
  username    = each.value
  password    = module.tenant_opensearch_password.result
  description = "Tenant user creation for ${each.value}"
}

resource "opensearch_role" "tenant_index_role" {
  depends_on = [opensearch_user.tenant_user]
  for_each   = local.users

  role_name           = "tenant-${each.value}-index-role"
  cluster_permissions = ["cluster_composite_ops_ro"]

  index_permissions {
    index_patterns = ["${each.value}*", "logs-pooled-${each.value}*"]
    allowed_actions = [
      "get",
      "search",
      "read",
      "indices:admin/get",
    ]
  }
}

resource "opensearch_roles_mapping" "user_role_mapping" {
  depends_on = [opensearch_user.tenant_user,
  opensearch_role.tenant_index_role]
  for_each = local.users

  role_name = opensearch_role.tenant_index_role[each.key].role_name
  users     = [opensearch_user.tenant_user[each.key].username]
}

resource "opensearch_roles_mapping" "user_role_mapping1" {
  depends_on = [opensearch_user.tenant_user]

  role_name = "opensearch_dashboards_user"
  users     = ["${var.tenant_tier}-${var.tenant}"]
}

resource "opensearch_roles_mapping" "user_role_mapping2" {
  depends_on = [opensearch_user.tenant_user]

  role_name = "index_management_read_access"
  users     = ["${var.tenant_tier}-${var.tenant}"]
}

resource "opensearch_dashboard_object" "test_index_pattern_v7" {
  for_each = local.users

  body = jsonencode([{
    "_id" : "index-pattern:${each.value}",
    "_type" : "string",
    "_source" : {
      "type" : "index-pattern",
      "index-pattern" : {
        "title" : "logs-pooled-${each.value}*",
        "timeFieldName" : "timestamp"
      }
    }
  }])
}

module "tenant_opensearch_parameters" {
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/opensearch_user"
      value       = var.tenant
      type        = "SecureString"
      overwrite   = "true"
      description = "${var.tenant_tier} Tenant Opensearch Username"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/opensearch_password"
      value       = module.tenant_opensearch_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "${var.tenant_tier} Tenant Opensearch Password"
    }
  ]
  tags = module.tags.tags
}