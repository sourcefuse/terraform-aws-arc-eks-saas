<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_cognito_user_pool"></a> [aws\_cognito\_user\_pool](#module\_aws\_cognito\_user\_pool) | ../../modules/cognito | n/a |
| <a name="module_cognito_domain_string"></a> [cognito\_domain\_string](#module\_cognito\_domain\_string) | ../../modules/random-password | n/a |
| <a name="module_cognito_ssm_parameters"></a> [cognito\_ssm\_parameters](#module\_cognito\_ssm\_parameters) | ../../modules/ssm-parameter | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_create_user_config"></a> [admin\_create\_user\_config](#input\_admin\_create\_user\_config) | The configuration for AdminCreateUser requests | `map(any)` | <pre>{<br>  "email_message": "Dear {username}, your verification code is {####}.",<br>  "email_subject": "Here, your verification code",<br>  "sms_message": "Your username is {username} and temporary password is {####}."<br>}</pre> | no |
| <a name="input_admin_create_user_config_allow_admin_create_user_only"></a> [admin\_create\_user\_config\_allow\_admin\_create\_user\_only](#input\_admin\_create\_user\_config\_allow\_admin\_create\_user\_only) | Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app | `bool` | `false` | no |
| <a name="input_alias_attributes"></a> [alias\_attributes](#input\_alias\_attributes) | Attributes supported as an alias for this user pool. Possible values: phone\_number, email, or preferred\_username. Conflicts with `username_attributes` | `list(string)` | <pre>[<br>  "email",<br>  "phone_number",<br>  "preferred_username"<br>]</pre> | no |
| <a name="input_auto_verified_attributes"></a> [auto\_verified\_attributes](#input\_auto\_verified\_attributes) | The attributes to be auto-verified. Possible values: email, phone\_number | `list(string)` | <pre>[<br>  "email"<br>]</pre> | no |
| <a name="input_callback_urls"></a> [callback\_urls](#input\_callback\_urls) | Enter Callback URLs | `list(string)` | `[]` | no |
| <a name="input_client_prevent_user_existence_errors"></a> [client\_prevent\_user\_existence\_errors](#input\_client\_prevent\_user\_existence\_errors) | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool. | `string` | `"ENABLED"` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | A container with the clients definitions | `any` | `[]` | no |
| <a name="input_default_redirect_url"></a> [default\_redirect\_url](#input\_default\_redirect\_url) | Enter default redirect URLs | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature. Valid values are `ACTIVE` and `INACTIVE`. | `string` | `"INACTIVE"` | no |
| <a name="input_device_configuration"></a> [device\_configuration](#input\_device\_configuration) | The configuration for the user pool's device tracking | `map(any)` | <pre>{<br>  "challenge_required_on_new_device": true,<br>  "device_only_remembered_on_user_prompt": true<br>}</pre> | no |
| <a name="input_email_configuration"></a> [email\_configuration](#input\_email\_configuration) | The Email Configuration | `map(any)` | <pre>{<br>  "email_sending_account": "COGNITO_DEFAULT",<br>  "reply_to_email_address": "",<br>  "source_arn": ""<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_identity_providers"></a> [identity\_providers](#input\_identity\_providers) | Cognito Pool Identity Providers | `list(any)` | `[]` | no |
| <a name="input_logout_urls"></a> [logout\_urls](#input\_logout\_urls) | Enter logout URLs | `list(string)` | `[]` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL) | `string` | `"OFF"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | A container for information about the user pool password policy | <pre>object({<br>    minimum_length                   = number,<br>    require_lowercase                = bool,<br>    require_numbers                  = bool,<br>    require_symbols                  = bool,<br>    require_uppercase                = bool,<br>    temporary_password_validity_days = number<br>  })</pre> | <pre>{<br>  "minimum_length": 10,<br>  "require_lowercase": true,<br>  "require_numbers": true,<br>  "require_symbols": true,<br>  "require_uppercase": true,<br>  "temporary_password_validity_days": 7<br>}</pre> | no |
| <a name="input_recovery_mechanisms"></a> [recovery\_mechanisms](#input\_recovery\_mechanisms) | The list of Account Recovery Options | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_resource_servers"></a> [resource\_servers](#input\_resource\_servers) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_sms_authentication_message"></a> [sms\_authentication\_message](#input\_sms\_authentication\_message) | A string representing the SMS authentication message | `string` | `"Your username is {username} and temporary password is {####}."` | no |
| <a name="input_sms_verification_message"></a> [sms\_verification\_message](#input\_sms\_verification\_message) | A string representing the SMS verification message | `string` | `"This is the verification message {####}."` | no |
| <a name="input_software_token_mfa_configuration"></a> [software\_token\_mfa\_configuration](#input\_software\_token\_mfa\_configuration) | Configuration block for software token MFA (multifactor-auth). mfa\_configuration must also be enabled for this to work | `map(any)` | `{}` | no |
| <a name="input_software_token_mfa_configuration_enabled"></a> [software\_token\_mfa\_configuration\_enabled](#input\_software\_token\_mfa\_configuration\_enabled) | If true, and if mfa\_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled | `bool` | `true` | no |
| <a name="input_user_groups"></a> [user\_groups](#input\_user\_groups) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_user_pool_add_ons_advanced_security_mode"></a> [user\_pool\_add\_ons\_advanced\_security\_mode](#input\_user\_pool\_add\_ons\_advanced\_security\_mode) | The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED` | `string` | `"OFF"` | no |
| <a name="input_username_configuration"></a> [username\_configuration](#input\_username\_configuration) | The Username Configuration. Setting `case_sensitive` specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs | `map(any)` | <pre>{<br>  "case_sensitive": false<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cognito_domain"></a> [cognito\_domain](#output\_cognito\_domain) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->