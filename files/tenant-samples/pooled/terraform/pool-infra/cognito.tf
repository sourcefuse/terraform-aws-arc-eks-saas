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

  source  = "lgallard/cognito-user-pool/aws"
  version = "0.24.0"

  user_pool_name                                        = "${var.namespace}-${var.environment}-${var.tenant_tier}-cognito-user-pool"
  alias_attributes                                      = var.alias_attributes
  auto_verified_attributes                              = var.auto_verified_attributes
  sms_authentication_message                            = var.sms_authentication_message
  sms_verification_message                              = var.sms_verification_message
  deletion_protection                                   = var.cognito_deletion_protection
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

  schemas = []

  string_schemas = []

  number_schemas = []

  # user_pool_domain
  domain = "${var.namespace}-${var.tenant_tier}-${module.cognito_domain_string.result}"


  # user_group
  user_groups = var.user_groups

  # resource_servers
  resource_servers = var.resource_servers

  # identity_providers
  identity_providers  = []
  recovery_mechanisms = var.recovery_mechanisms

  # tags
  tags = module.tags.tags
}

######################################################################
## Store Congito output to SSM parameneter store
######################################################################
module "cognito_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_domain"
      value       = "https://${var.namespace}-${var.tenant_tier}-${module.cognito_domain_string.result}.auth.${var.region}.amazoncognito.com"
      type        = "SecureString"
      overwrite   = "true"
      description = "Pooled Tenant Cognito Domain Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_user_pool_id"
      value       = module.aws_cognito_user_pool.id
      type        = "SecureString"
      overwrite   = "true"
      description = "Cognito User Pool ID"
    }
  ]
  tags = module.tags.tags
}


