######################################################################
## tags
######################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

######################################################################
## random string
######################################################################
module "cognito_domain_string" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}

######################################################################
## Cognito User Pool
######################################################################
module "aws_cognito_user_pool" {
  source = "../../modules/cognito"

  user_pool_name             = "${var.namespace}-${var.environment}-cognito-user-pool"
  alias_attributes           = var.alias_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  sms_authentication_message = var.sms_authentication_message
  sms_verification_message   = var.sms_verification_message
  deletion_protection        = var.deletion_protection

  mfa_configuration                                     = var.mfa_configuration
  software_token_mfa_configuration                      = var.software_token_mfa_configuration
  admin_create_user_config                              = var.admin_create_user_config
  admin_create_user_config_allow_admin_create_user_only = var.admin_create_user_config_allow_admin_create_user_only
  device_configuration                                  = var.device_configuration
  email_configuration                                   = var.email_configuration
  password_policy                                       = var.password_policy

  user_pool_add_ons = {
    advanced_security_mode = var.user_pool_add_ons_advanced_security_mode
  }

  verification_message_template = {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  domain = "${var.namespace}-${module.cognito_domain_string.result}"

  clients = [{
    allowed_oauth_flows                  = ["code"]
    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_scopes                 = ["phone", "email", "openid", "aws.cognito.signin.user.admin"]
    callback_urls                        = var.callback_urls
    default_redirect_url                 = var.default_redirect_url
    logout_urls                          = var.logout_urls
    explicit_auth_flows                  = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
    generate_secret                      = true
    name                                 = var.namespace
    read_attributes                      = ["email", "address", "birthdate", "email_verified", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
    supported_identity_providers         = ["COGNITO"]
    write_attributes                     = []
    access_token_validity                = 60
    id_token_validity                    = 60
    refresh_token_validity               = 30
    token_validity_units = {
      access_token  = "minutes"
      id_token      = "minutes"
      refresh_token = "days"
    }
  }]

  # user_group
  user_groups = var.user_groups

  # resource_servers
  resource_servers = var.resource_servers

  # identity_providers
  identity_providers  = []
  recovery_mechanisms = var.recovery_mechanisms

  tags = module.tags.tags
}

######################################################################
## Store Congito output to SSM parameneter store
######################################################################
module "cognito_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/cognito_domain"
      value       = "https://${var.namespace}-${module.cognito_domain_string.result}.auth.${var.region}.amazoncognito.com"
      type        = "SecureString"
      overwrite   = "true"
      description = "Cognito Domain Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/cognito_id"
      value       = module.aws_cognito_user_pool.client_ids[0]
      type        = "SecureString"
      overwrite   = "true"
      description = "Cognito Domain ID"
    },
    {
      name        = "/${var.namespace}/${var.environment}/cognito_secret"
      value       = module.aws_cognito_user_pool.client_secrets[0]
      type        = "SecureString"
      overwrite   = "true"
      description = "Cognito Domain Secret"
    }
  ]
  tags = module.tags.tags
}