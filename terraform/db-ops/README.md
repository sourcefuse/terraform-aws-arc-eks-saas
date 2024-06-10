<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db_ops_ssm_parameters"></a> [db\_ops\_ssm\_parameters](#module\_db\_ops\_ssm\_parameters) | ../../modules/ssm-parameter | n/a |
| <a name="module_postgresql_provider"></a> [postgresql\_provider](#module\_postgresql\_provider) | ../../modules/postgresql | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ssm_parameter.db_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auditdbdatabase"></a> [auditdbdatabase](#input\_auditdbdatabase) | ################################################################################# # Postgres DBs ################################################################################# | `string` | `"audit"` | no |
| <a name="input_aurora_db_name"></a> [aurora\_db\_name](#input\_aurora\_db\_name) | Database name. | `string` | `"auroradb"` | no |
| <a name="input_authenticationdbdatabase"></a> [authenticationdbdatabase](#input\_authenticationdbdatabase) | n/a | `string` | `"auth"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_featuretoggledbdatabase"></a> [featuretoggledbdatabase](#input\_featuretoggledbdatabase) | n/a | `string` | `"feature"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_notificationdbdatabase"></a> [notificationdbdatabase](#input\_notificationdbdatabase) | n/a | `string` | `"notification"` | no |
| <a name="input_paymentdbdatabase"></a> [paymentdbdatabase](#input\_paymentdbdatabase) | n/a | `string` | `"payment"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_subscriptiondbdatabase"></a> [subscriptiondbdatabase](#input\_subscriptiondbdatabase) | n/a | `string` | `"subscription"` | no |
| <a name="input_tenantmgmtdbdatabase"></a> [tenantmgmtdbdatabase](#input\_tenantmgmtdbdatabase) | n/a | `string` | `"tenantmgmt"` | no |
| <a name="input_userdbdatabase"></a> [userdbdatabase](#input\_userdbdatabase) | n/a | `string` | `"user"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->