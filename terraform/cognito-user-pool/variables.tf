###############################################################
## Default
################################################################
variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

###################################################################
## Cognito User Pool
###################################################################
variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username. Conflicts with `username_attributes`"
  type        = list(string)
  default     = ["email", "phone_number", "preferred_username"]
}

variable "auto_verified_attributes" {
  description = "The attributes to be auto-verified. Possible values: email, phone_number"
  type        = list(string)
  default     = ["email"]
}

variable "sms_authentication_message" {
  description = "A string representing the SMS authentication message"
  type        = string
  default     = "Your username is {username} and temporary password is {####}."
}

variable "sms_verification_message" {
  description = "A string representing the SMS verification message"
  type        = string
  default     = "This is the verification message {####}."
}

variable "deletion_protection" {
  description = "When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature. Valid values are `ACTIVE` and `INACTIVE`."
  type        = string
  default     = "INACTIVE"
}

variable "mfa_configuration" {
  description = "Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL)"
  type        = string
  default     = "OFF"
}

variable "software_token_mfa_configuration" {
  description = "Configuration block for software token MFA (multifactor-auth). mfa_configuration must also be enabled for this to work"
  type        = map(any)
  default     = {}
}

variable "software_token_mfa_configuration_enabled" {
  description = "If true, and if mfa_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled"
  type        = bool
  default     = true
}

variable "admin_create_user_config" {
  description = "The configuration for AdminCreateUser requests"
  type        = map(any)
  default = {
    email_message = "Dear {username}, your verification code is {####}."
    email_subject = "Here, your verification code"
    sms_message   = "Your username is {username} and temporary password is {####}."
  }
}

variable "admin_create_user_config_allow_admin_create_user_only" {
  description = "Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app"
  type        = bool
  default     = false
}

variable "username_configuration" {
  description = "The Username Configuration. Setting `case_sensitive` specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs"
  type        = map(any)
  default     = { case_sensitive = false }
}

# device_configuration
variable "device_configuration" {
  description = "The configuration for the user pool's device tracking"
  type        = map(any)
  default = {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }
}

# email_configuration
variable "email_configuration" {
  description = "The Email Configuration"
  type        = map(any)
  default = {
    email_sending_account  = "COGNITO_DEFAULT"
    reply_to_email_address = ""
    source_arn             = ""
  }
}


# password_policy
variable "password_policy" {
  description = "A container for information about the user pool password policy"
  type = object({
    minimum_length                   = number,
    require_lowercase                = bool,
    require_numbers                  = bool,
    require_symbols                  = bool,
    require_uppercase                = bool,
    temporary_password_validity_days = number
  })
  default = {
    minimum_length                   = 10
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
}

variable "user_pool_add_ons_advanced_security_mode" {
  description = "The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED`"
  type        = string
  default     = "OFF"
}

# aws_cognito_user_pool

variable "user_groups" {
  description = "A container with the user_groups definitions"
  type        = list(any)
  default     = []
}

variable "clients" {
  description = "A container with the clients definitions"
  type        = any
  default     = []
}

variable "client_prevent_user_existence_errors" {
  description = "Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool."
  type        = string
  default     = "ENABLED"
}

variable "resource_servers" {
  description = "A container with the user_groups definitions"
  type        = list(any)
  default     = []
}

# aws_cognito_identity_provider
variable "identity_providers" {
  description = "Cognito Pool Identity Providers"
  type        = list(any)
  default     = []
  sensitive   = true
}

# Account Recovery Setting
variable "recovery_mechanisms" {
  description = "The list of Account Recovery Options"
  type        = list(any)
  default     = []
}

# Urls
variable "callback_urls" {
  description = "Enter Callback URLs"
  type        = list(string)
  default     = []
}

variable "default_redirect_url" {
  description = "Enter default redirect URLs"
  type        = string
  default     = ""
}

variable "logout_urls" {
  description = "Enter logout URLs"
  type        = list(string)
  default     = []
}

