<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_allow_database_connection_security_group"></a> [allow\_database\_connection\_security\_group](#module\_allow\_database\_connection\_security\_group) | ../../modules/security-group | n/a |
| <a name="module_network"></a> [network](#module\_network) | sourcefuse/arc-network/aws | 2.6.10 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to deploy resources in. | `list(string)` | <pre>[<br>  "us-east-1a",<br>  "us-east-1b"<br>]</pre> | no |
| <a name="input_client_vpn_authorization_rules"></a> [client\_vpn\_authorization\_rules](#input\_client\_vpn\_authorization\_rules) | List of objects describing the authorization rules for the client vpn | `list(map(any))` | `[]` | no |
| <a name="input_client_vpn_enabled"></a> [client\_vpn\_enabled](#input\_client\_vpn\_enabled) | Enable client VPN endpoint | `bool` | `false` | no |
| <a name="input_custom_create_aws_network_acl"></a> [custom\_create\_aws\_network\_acl](#input\_custom\_create\_aws\_network\_acl) | This indicates whether to create aws network acl or not | `bool` | `true` | no |
| <a name="input_custom_nat_gateway_enabled"></a> [custom\_nat\_gateway\_enabled](#input\_custom\_nat\_gateway\_enabled) | Enable the NAT Gateway between public and private subnets | `bool` | `true` | no |
| <a name="input_custom_private_subnet_ids"></a> [custom\_private\_subnet\_ids](#input\_custom\_private\_subnet\_ids) | list of CIDR block for private subnets | `list(string)` | `[]` | no |
| <a name="input_custom_public_subnet_ids"></a> [custom\_public\_subnet\_ids](#input\_custom\_public\_subnet\_ids) | list of CIDR block for public subnets | `list(string)` | `[]` | no |
| <a name="input_enable_cloudwatch_endpoint"></a> [enable\_cloudwatch\_endpoint](#input\_enable\_cloudwatch\_endpoint) | Enable CloudWatch endpoints | `bool` | `false` | no |
| <a name="input_enable_dynamodb_endpoint"></a> [enable\_dynamodb\_endpoint](#input\_enable\_dynamodb\_endpoint) | Enable DynamoDB endpoints | `bool` | `false` | no |
| <a name="input_enable_ec2_endpoint"></a> [enable\_ec2\_endpoint](#input\_enable\_ec2\_endpoint) | Enable EC2 endpoints | `bool` | `false` | no |
| <a name="input_enable_ecs_endpoint"></a> [enable\_ecs\_endpoint](#input\_enable\_ecs\_endpoint) | Enable ECS endpoints | `bool` | `false` | no |
| <a name="input_enable_elb_endpoint"></a> [enable\_elb\_endpoint](#input\_enable\_elb\_endpoint) | Enable ELB endpoints | `bool` | `false` | no |
| <a name="input_enable_kms_endpoint"></a> [enable\_kms\_endpoint](#input\_enable\_kms\_endpoint) | Enable KMS endpoints | `bool` | `false` | no |
| <a name="input_enable_rds_endpoint"></a> [enable\_rds\_endpoint](#input\_enable\_rds\_endpoint) | Enable RDS endpoints | `bool` | `false` | no |
| <a name="input_enable_s3_endpoint"></a> [enable\_s3\_endpoint](#input\_enable\_s3\_endpoint) | Enable S3 endpoints | `bool` | `false` | no |
| <a name="input_enable_sns_endpoint"></a> [enable\_sns\_endpoint](#input\_enable\_sns\_endpoint) | Enable SNS endpoints | `bool` | `false` | no |
| <a name="input_enable_sqs_endpoint"></a> [enable\_sqs\_endpoint](#input\_enable\_sqs\_endpoint) | Enable SQS endpoints | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_is_custom_subnet_enabled"></a> [is\_custom\_subnet\_enabled](#input\_is\_custom\_subnet\_enabled) | Enable to create subnets with custom cidr range | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_private_subnet_count"></a> [private\_subnet\_count](#input\_private\_subnet\_count) | Number of private subnets required | `number` | `2` | no |
| <a name="input_public_subnet_count"></a> [public\_subnet\_count](#input\_public\_subnet\_count) | Number of public subnets required | `number` | `2` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_vpc_endpoint_type"></a> [vpc\_endpoint\_type](#input\_vpc\_endpoint\_type) | The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface. | `string` | `"Interface"` | no |
| <a name="input_vpc_endpoints_enabled"></a> [vpc\_endpoints\_enabled](#input\_vpc\_endpoints\_enabled) | Enable VPC endpoints. | `bool` | `false` | no |
| <a name="input_vpc_ipv4_primary_cidr_block"></a> [vpc\_ipv4\_primary\_cidr\_block](#input\_vpc\_ipv4\_primary\_cidr\_block) | CIDR block for the VPC to use. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet_names"></a> [private\_subnet\_names](#output\_private\_subnet\_names) | Private subnet Names |
| <a name="output_public_subnet_names"></a> [public\_subnet\_names](#output\_public\_subnet\_names) | Public subnet Names |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | The VPC CIDR block |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | Name of VPC |
| <a name="output_vpn_endpoint_dns_name"></a> [vpn\_endpoint\_dns\_name](#output\_vpn\_endpoint\_dns\_name) | The DNS Name of the Client VPN Endpoint Connection. |
<!-- END_TF_DOCS -->