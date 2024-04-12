# Terraform Module: Security Group  

## Overview

AWS SSM Parameter for the ARC SAAS Infrastructure.  

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [ssm\_parameter\_description](#input\_description) | Description of the SSM Parameter | `string` | `"my-ssm-parameter"` | no |
| <a name="input_name"></a> [ssm\_parameter\_name](#input\_name) | Name of the SSM Parameter | `string` | `"my-ssm-parameter"` | yes |
| <a name="input_type"></a> [ssm\_parameter\_type](#input\_type) | Type of the SSM Parameter | `string` | `"String"` | yes |
| <a name="input_value"></a> [ssm\_parameter\_value](#input\_value) | Value of the SSM Parameter | `string` | `""` | yes |
| <a name="input_overwrite"></a> [ssm\_parameter\_overwrite](#input\_overwrite) | Overwrite an existing parameter | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign the security groups. | `map(string)` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="ssm_parameter_name"></a> [ssm_parameter_name](#output\_name) | The Name of SSM Parameter |
| <a name="ssm_parameter_value"></a> [ssm_parameter_value](#output\_value) | The Value of SSM Parameter |
| <a name="ssm_parameter_arn"></a> [ssm_parameter_arn](#output\_arn) | The ARN of SSM Parameter |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parameter_defaults"></a> [parameter\_defaults](#input\_parameter\_defaults) | Parameter write default settings | `map(any)` | <pre>{<br>  "description": null,<br>  "overwrite": "false",<br>  "tier": "Standard",<br>  "type": "SecureString"<br>}</pre> | no |
| <a name="input_ssm_parameters"></a> [ssm\_parameters](#input\_ssm\_parameters) | List of maps with the parameter values to write to SSM Parameter Store | `list(map(string))` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign the security groups. | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->