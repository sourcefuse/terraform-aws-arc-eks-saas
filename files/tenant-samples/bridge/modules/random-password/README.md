# Terraform Module: Security Group  

## Overview

Random String Geneartor for the ARC SAAS Infrastructure.  

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
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_length"></a> [length](#input\_description) | The length of the string desired | `number` | `1` | yes |
| <a name="input_is_special"></a> [is\_special](#input\_is\_special) | Include special characters in the result. | `bool` | `true` | no |
| <a name="input_is_lower"></a> [is\_lower](#input\_is\_lower) | Include lower characters in the result. | `bool` | `true` | no |
| <a name="input_is_upper"></a> [is\_upper](#input\_is\_upper) | Include upper characters in the result. | `bool` | `true` | no |
| <a name="input_is_numeric"></a> [is\_numeric](#input\_is\_numeric) | Include numeric characters in the result. | `bool` | `true` | no |
| <a name="input_override_special"></a> [override\_special](#input\_override\_special) | Supply your own list of special characters to use for string generation | `string` | `""` | no |
| <a name="min_upper"></a> [min\_upper](#input\_min\_upper) | Minimum number of uppercase alphabet characters in the result | `number` | `0` | no |
| <a name="min_lower"></a> [min\_lower](#input\_min\_lower) | Minimum number of lowercase alphabet characters in the result | `number` | `0` | no |
| <a name="min_numeric"></a> [min\_numeric](#input\_min\_numeric) | Minimum number of numeric characters in the result | `number` | `0` | no |




## Outputs

| Name | Description |
|------|-------------|
| <a name="result"></a> [result](#output\_result) | The generated random string |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_is_lower"></a> [is\_lower](#input\_is\_lower) | Include lowercase alphabet characters in the result | `bool` | `"true"` | no |
| <a name="input_is_numeric"></a> [is\_numeric](#input\_is\_numeric) | Include numeric characters in the result | `bool` | `"true"` | no |
| <a name="input_is_special"></a> [is\_special](#input\_is\_special) | Include special characters in the result. | `bool` | `"true"` | no |
| <a name="input_is_upper"></a> [is\_upper](#input\_is\_upper) | Include uppercase alphabet characters in the result | `bool` | `"true"` | no |
| <a name="input_length"></a> [length](#input\_length) | The length of the string desired. | `number` | `"1"` | no |
| <a name="input_min_lower"></a> [min\_lower](#input\_min\_lower) | Minimum number of lowercase alphabet characters in the result | `number` | `0` | no |
| <a name="input_min_numeric"></a> [min\_numeric](#input\_min\_numeric) | Minimum number of numeric characters in the result | `number` | `0` | no |
| <a name="input_min_special"></a> [min\_special](#input\_min\_special) | Minimum number of special characters in the result | `number` | `0` | no |
| <a name="input_min_upper"></a> [min\_upper](#input\_min\_upper) | Minimum number of uppercase alphabet characters in the result | `number` | `0` | no |
| <a name="input_override_special"></a> [override\_special](#input\_override\_special) | Supply your own list of special characters to use for string generation | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_result"></a> [result](#output\_result) | The generated random string |
<!-- END_TF_DOCS -->