<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | = 2.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | = 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

| Name | Type |
|------|------|
| [aws_synthetics_canary.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [archive_file.canary_zip_inline](https://registry.terraform.io/providers/hashicorp/archive/2.2.0/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_ssm_parameter.canary_report_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | The path for the API call , ex: /path?param=value. | `string` | `"/main/home"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_frequency"></a> [frequency](#input\_frequency) | The frequency in minutes at which the canary should be run. The minimum is two minutes. | `string` | `"6"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Runtime version of the canary. Details: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Library_nodejs_puppeteer.html | `string` | `"syn-nodejs-puppeteer-7.0"` | no |
| <a name="input_take_screenshot"></a> [take\_screenshot](#input\_take\_screenshot) | If screenshot should be taken | `bool` | `false` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | tenant name | `string` | n/a | yes |
| <a name="input_tenant_host_domain"></a> [tenant\_host\_domain](#input\_tenant\_host\_domain) | tenant Host | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenat unique ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->