<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup"></a> [backup](#module\_backup) | sourcefuse/arc-backup/aws | 0.0.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

| Name | Type |
|------|------|
| [null_resource.run_backup_script](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_ssm_parameter.db_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | tenant name | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenat unique ID | `string` | n/a | yes |
| <a name="input_tenant_tier"></a> [tenant\_tier](#input\_tenant\_tier) | Tenant Tier | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_role_arn"></a> [backup\_role\_arn](#output\_backup\_role\_arn) | IAM Role for taking backups |
| <a name="output_vault_arn"></a> [vault\_arn](#output\_vault\_arn) | Vault ARN |
<!-- END_TF_DOCS -->