<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | >= 3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | cloudposse/api-gateway/aws | 0.7.0 |
| <a name="module_api_gw_ssm_parameters"></a> [api\_gw\_ssm\_parameters](#module\_api\_gw\_ssm\_parameters) | ../../modules/ssm-parameter | n/a |
| <a name="module_eventbridge"></a> [eventbridge](#module\_eventbridge) | terraform-aws-modules/eventbridge/aws | 3.7.1 |
| <a name="module_eventbridge_role"></a> [eventbridge\_role](#module\_eventbridge\_role) | ../../modules/iam-role | n/a |
| <a name="module_lambda_function_container_image"></a> [lambda\_function\_container\_image](#module\_lambda\_function\_container\_image) | terraform-aws-modules/lambda/aws | 7.6.0 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_target.api_gateway_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.decoupling_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_dynamodb_table.orchestrator_data_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table.tier_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_dynamodb_table_item.basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_dynamodb_table_item.premium](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_dynamodb_table_item.standard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table_item) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.resource_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.api_gw_url](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.karpenter_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.orchestrator_ecr_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compatible_architectures"></a> [compatible\_architectures](#input\_compatible\_architectures) | Lambda layer compatible architectures | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_control_plane_host"></a> [control\_plane\_host](#input\_control\_plane\_host) | Host Name of the control plane | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name of the control plane | `string` | `""` | no |
| <a name="input_dynamo_kms_master_key_id"></a> [dynamo\_kms\_master\_key\_id](#input\_dynamo\_kms\_master\_key\_id) | The Default ID of an AWS-managed customer master key (CMK) for Amazon Dynamo | `string` | `null` | no |
| <a name="input_dynamodb_hash_key"></a> [dynamodb\_hash\_key](#input\_dynamodb\_hash\_key) | The attribute to use as the hash (partition) key for tenant dynamodb table. | `string` | `"tier"` | no |
| <a name="input_enable_dynamodb_point_in_time_recovery"></a> [enable\_dynamodb\_point\_in\_time\_recovery](#input\_enable\_dynamodb\_point\_in\_time\_recovery) | Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables. | `bool` | `true` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | The type of the endpoint. One of - PUBLIC, PRIVATE, REGIONAL | `string` | `"EDGE"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | env variables for the code | `map(any)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB). | `number` | `1024` | no |
| <a name="input_logging_level"></a> [logging\_level](#input\_logging\_level) | The logging level of the API. One of - OFF, INFO, ERROR | `string` | `"INFO"` | no |
| <a name="input_maximum_retry_attempts"></a> [maximum\_retry\_attempts](#input\_maximum\_retry\_attempts) | Maximum number of times to retry when the function returns an error. Valid values between 0 and 2. Defaults to 2. | `number` | `0` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size for Lambda function | `number` | `1024` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this Lambda Function. A value of 0 disables Lambda Function from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. | `number` | `-1` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Lambda function timeout in seconds | `number` | `300` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->