<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.4.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | >= 2.9.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.4.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_canary_infra"></a> [canary\_infra](#module\_canary\_infra) | ../../..modules/canary-infra | n/a |
| <a name="module_canary_ssm_parameters"></a> [canary\_ssm\_parameters](#module\_canary\_ssm\_parameters) | ../../../modules/ssm-parameter | n/a |
| <a name="module_grafana"></a> [grafana](#module\_grafana) | ../../../modules/aws-managed-grafana | n/a |
| <a name="module_observability_ssm_parameters"></a> [observability\_ssm\_parameters](#module\_observability\_ssm\_parameters) | ../../../modules/ssm-parameter | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../../../modules/eks-monitoring | n/a |
| <a name="module_prometheus_service_account_role"></a> [prometheus\_service\_account\_role](#module\_prometheus\_service\_account\_role) | ../../../modules/iam-role | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |

## Resources

| Name | Type |
|------|------|
| [helm_release.kuberhealthy](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [local_file.grafana_gateway](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.grafana_virtual_service](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.apply_manifests](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.prometheus_sa_policy](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name | `string` | `"arc-saas.net"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | AWS Managed grafana version | `string` | `"9.4"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_workspace_api_keys_keyname"></a> [workspace\_api\_keys\_keyname](#input\_workspace\_api\_keys\_keyname) | Workspace api key base key name | `string` | `"admin"` | no |
| <a name="input_workspace_api_keys_keyrole"></a> [workspace\_api\_keys\_keyrole](#input\_workspace\_api\_keys\_keyrole) | Workspace api key base key role like ADMIN, VIEWER, EDITOR etc | `string` | `"ADMIN"` | no |
| <a name="input_workspace_api_keys_ttl"></a> [workspace\_api\_keys\_ttl](#input\_workspace\_api\_keys\_ttl) | Workspace api key base key  time to live in seconds . Specifies the time in seconds until the API key expires. Keys can be valid for up to 30 days | `number` | `9000` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_api_key"></a> [grafana\_api\_key](#output\_grafana\_api\_key) | n/a |
| <a name="output_grafana_url"></a> [grafana\_url](#output\_grafana\_url) | Amazon Managed Grafana Workspace endpoint |
| <a name="output_grafana_workspace_iam_role_arn"></a> [grafana\_workspace\_iam\_role\_arn](#output\_grafana\_workspace\_iam\_role\_arn) | Amazon Managed Grafana Workspace's IAM Role ARN |
| <a name="output_grafana_workspace_id"></a> [grafana\_workspace\_id](#output\_grafana\_workspace\_id) | Amazon Managed Grafana Workspace ID |
<!-- END_TF_DOCS -->