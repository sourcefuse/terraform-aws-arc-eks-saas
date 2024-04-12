# Amazon Managed Grafana Workspace Setup

This example creates an Amazon Managed Grafana Workspace with
Amazon CloudWatch, AWS X-Ray and Amazon Managed Service for Prometheus
datasources

The authentication method chosen for this example is with IAM Identity
Center (former SSO). You can extend this example to add SAML.

Step-by-step instructions available on our [docs site](https://aws-observability.github.io/terraform-aws-observability-accelerator/)
under **Supporting Examples**

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_managed_grafana"></a> [managed\_grafana](#module\_managed\_grafana) | terraform-aws-modules/managed-service-grafana/aws | 1.10.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_aws\_region) | AWS Region | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_workspace_endpoint"></a> [grafana\_workspace\_endpoint](#output\_grafana\_workspace\_endpoint) | Amazon Managed Grafana Workspace endpoint |
| <a name="output_grafana_workspace_iam_role_arn"></a> [grafana\_workspace\_iam\_role\_arn](#output\_grafana\_workspace\_iam\_role\_arn) | Amazon Managed Grafana Workspace's IAM Role ARN |
| <a name="output_grafana_workspace_id"></a> [grafana\_workspace\_id](#output\_grafana\_workspace\_id) | Amazon Managed Grafana Workspace ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_managed_grafana"></a> [managed\_grafana](#module\_managed\_grafana) | terraform-aws-modules/managed-service-grafana/aws | 1.10.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | AWS Managed grafana version | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_workspace_api_keys_keyname"></a> [workspace\_api\_keys\_keyname](#input\_workspace\_api\_keys\_keyname) | Workspace api key base key name | `string` | n/a | yes |
| <a name="input_workspace_api_keys_keyrole"></a> [workspace\_api\_keys\_keyrole](#input\_workspace\_api\_keys\_keyrole) | Workspace api key base key role like ADMIN, VIEWER, EDITOR etc | `string` | n/a | yes |
| <a name="input_workspace_api_keys_ttl"></a> [workspace\_api\_keys\_ttl](#input\_workspace\_api\_keys\_ttl) | Workspace api key base key  time to live in seconds . Specifies the time in seconds until the API key expires. Keys can be valid for up to 30 days | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_workspace_endpoint"></a> [grafana\_workspace\_endpoint](#output\_grafana\_workspace\_endpoint) | Amazon Managed Grafana Workspace endpoint |
| <a name="output_grafana_workspace_iam_role_arn"></a> [grafana\_workspace\_iam\_role\_arn](#output\_grafana\_workspace\_iam\_role\_arn) | Amazon Managed Grafana Workspace's IAM Role ARN |
| <a name="output_grafana_workspace_id"></a> [grafana\_workspace\_id](#output\_grafana\_workspace\_id) | Amazon Managed Grafana Workspace ID |
| <a name="output_granafa_workspace_api_key"></a> [granafa\_workspace\_api\_key](#output\_granafa\_workspace\_api\_key) | n/a |
<!-- END_TF_DOCS -->