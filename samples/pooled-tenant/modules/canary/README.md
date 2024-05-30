<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.canary_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_synthetics_canary.canary_api_calls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [archive_file.lambda_canary_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.s3_canaries-reports](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_sns_topic"></a> [alert\_sns\_topic](#input\_alert\_sns\_topic) | The SNS topic to notify when canary fails | `string` | n/a | yes |
| <a name="input_api_hostname"></a> [api\_hostname](#input\_api\_hostname) | hostname to test | `string` | n/a | yes |
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | path to test | `string` | n/a | yes |
| <a name="input_frequency"></a> [frequency](#input\_frequency) | frequency of tests in minutes | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the canary | `string` | n/a | yes |
| <a name="input_reports-bucket"></a> [reports-bucket](#input\_reports-bucket) | Name of the bucket storing canary results | `string` | n/a | yes |
| <a name="input_role"></a> [role](#input\_role) | Role to execute the canaries | `string` | n/a | yes |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Runtime version | `string` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Security Groups used by the canary | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs in which to execute the canary | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign the resources | `map(string)` | n/a | yes |
| <a name="input_take_screenshot"></a> [take\_screenshot](#input\_take\_screenshot) | If screenshot should be taken | `bool` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->