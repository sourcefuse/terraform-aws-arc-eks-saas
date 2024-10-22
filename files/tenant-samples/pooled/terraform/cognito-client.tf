#####################################################################################
## Cognito App Client
#####################################################################################
resource "aws_cognito_user_pool_client" "app_client" {
  count = var.IdP == "cognito" ? 1 : 0
  name                                 = var.tenant
  user_pool_id                         = data.aws_ssm_parameter.cognito_user_pool_id[0].value
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["phone", "email", "openid", "aws.cognito.signin.user.admin"]
  callback_urls                        = ["https://${var.tenant}.${var.domain_name}/authentication-service/auth/cognito-auth-redirect"]
  default_redirect_uri                 = "https://${var.tenant}.${var.domain_name}/authentication-service/auth/cognito-auth-redirect"
  explicit_auth_flows                  = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
  generate_secret                      = true
  logout_urls                          = ["https://${var.tenant}.${var.domain_name}"]
  read_attributes                      = ["email", "address", "birthdate", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
  supported_identity_providers         = ["COGNITO"]
  write_attributes                     = []
  access_token_validity                = 60
  id_token_validity                    = 60
  refresh_token_validity               = 30
  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}

######################################################################
## Store Congito output to SSM parameneter store
######################################################################
module "cognito_ssm_parameters" {
  count = var.IdP == "cognito" ? 1 : 0
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_id"
      value       = resource.aws_cognito_user_pool_client.app_client[count.index].id
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Cognito Domain ID"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_secret"
      value       = resource.aws_cognito_user_pool_client.app_client[count.index].client_secret
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Cognito Domain Secret"
    }

  ]
  tags = module.tags.tags
}


module "keycloak_client_secret" {
  count = var.IdP == "keycloak" ? 1 : 0
  source     = "../modules/random-password"
  length     = 8
  is_special = false
  is_upper   = true
}

module "keycloak_ssm_parameters" {
  count = var.IdP == "keycloak" ? 1 : 0
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/keycloak-client-id"
      value       = "client-${var.tenant_tier}-${var.tenant}"
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Keycloak Client ID"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/keycloak-client-secret"
      value       = module.keycloak_client_secret[0].result
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Keycloak Client Secret"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/keycloak-client-realm"
      value       = "${var.tenant_tier}-${var.tenant}"
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Keycloak Client Realm"
    }
  ]
  tags = module.tags.tags
}