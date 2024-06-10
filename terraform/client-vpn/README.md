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
| <a name="module_self_signed_cert_ca"></a> [self\_signed\_cert\_ca](#module\_self\_signed\_cert\_ca) | git::https://github.com/cloudposse/terraform-aws-ssm-tls-self-signed-cert.git | 1.3.0 |
| <a name="module_self_signed_cert_root"></a> [self\_signed\_cert\_root](#module\_self\_signed\_cert\_root) | git::https://github.com/cloudposse/terraform-aws-ssm-tls-self-signed-cert.git | 1.3.0 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | sourcefuse/arc-vpn/aws | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.ca_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authentication_options_type"></a> [authentication\_options\_type](#input\_authentication\_options\_type) | The type of client authentication to be used.<br>Specify certificate-authentication to use certificate-based authentication, directory-service-authentication to use Active Directory authentication,<br>or federated-authentication to use Federated Authentication via SAML 2.0. | `string` | `"certificate-authentication"` | no |
| <a name="input_client_vpn_ingress_rules"></a> [client\_vpn\_ingress\_rules](#input\_client\_vpn\_ingress\_rules) | Ingress rules for the security groups. | <pre>list(object({<br>    description        = optional(string, "")<br>    from_port          = number<br>    to_port            = number<br>    protocol           = any<br>    cidr_blocks        = optional(list(string), [])<br>    security_group_ids = optional(list(string), [])<br>    ipv6_cidr_blocks   = optional(list(string), [])<br>  }))</pre> | <pre>[<br>  {<br>    "description": "VPN ingress to 443",<br>    "from_port": 443,<br>    "protocol": "tcp",<br>    "to_port": 443<br>  }<br>]</pre> | no |
| <a name="input_client_vpn_log_options"></a> [client\_vpn\_log\_options](#input\_client\_vpn\_log\_options) | Whether logging is enabled and where to send the logs output. | <pre>object({<br>    enabled               = bool                   // Indicates whether connection logging is enabled<br>    cloudwatch_log_stream = optional(string, null) // The name of the vpn client cloudwatch log stream<br>    cloudwatch_log_group  = optional(string, null) // The name of the vpn client cloudwatch log group<br>  })</pre> | <pre>{<br>  "enabled": false<br>}</pre> | no |
| <a name="input_client_vpn_name"></a> [client\_vpn\_name](#input\_client\_vpn\_name) | The name of the client vpn | `string` | `"saas-vpn"` | no |
| <a name="input_common_name"></a> [common\_name](#input\_common\_name) | Domain Name  supplied as commn name. | `string` | n/a | yes |
| <a name="input_enable_client_vpn"></a> [enable\_client\_vpn](#input\_enable\_client\_vpn) | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_private_subnet_names_override"></a> [private\_subnet\_names\_override](#input\_private\_subnet\_names\_override) | The name of the subnets to associate to the VPN. | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_secret_path_format"></a> [secret\_path\_format](#input\_secret\_path\_format) | The path format to use when writing secrets to the certificate backend. | `string` | `"/%s.%s"` | no |
| <a name="input_vpc_name_override"></a> [vpc\_name\_override](#input\_vpc\_name\_override) | The name of the target network VPC. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->