######################################################################
## Create Cognito User
######################################################################
module "cognito_password" {
  source      = "../modules/random-password"
  length      = 12
  is_special  = true
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  min_lower   = 1
}

#####################################################################################
## Cognito App Client
#####################################################################################
resource "aws_cognito_user_pool_client" "app_client" {
  name                                 = var.tenant
  user_pool_id                         = data.aws_ssm_parameter.cognito_user_pool_id.value
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

resource "aws_cognito_user" "cognito_user" {
  user_pool_id = data.aws_ssm_parameter.cognito_user_pool_id.value
  username     = var.user_name

  attributes = {
    email          = var.tenant_email
    email_verified = true
  }
  temporary_password = module.cognito_password.result

}

######################################################################
## Store Congito output to SSM parameneter store
######################################################################
module "cognito_ssm_parameters" {
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_id"
      value       = resource.aws_cognito_user_pool_client.app_client.id
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Cognito Domain ID"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_secret"
      value       = resource.aws_cognito_user_pool_client.app_client.client_secret
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Cognito Domain Secret"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/${var.user_name}/user_sub"
      value       = aws_cognito_user.cognito_user.sub
      type        = "SecureString"
      overwrite   = "true"
      description = "${var.tenant} User Cognito Sub"
    }
  ]
  tags = module.tags.tags
}