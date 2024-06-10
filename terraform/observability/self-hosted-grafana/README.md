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
| <a name="module_canary_infra"></a> [canary\_infra](#module\_canary\_infra) | ../../../modules/canary-infra | n/a |
| <a name="module_canary_ssm_parameters"></a> [canary\_ssm\_parameters](#module\_canary\_ssm\_parameters) | ../../../modules/ssm-parameter | n/a |
| <a name="module_grafana_password"></a> [grafana\_password](#module\_grafana\_password) | ../../../modules/random-password | n/a |
| <a name="module_grafana_ssm_parameters"></a> [grafana\_ssm\_parameters](#module\_grafana\_ssm\_parameters) | ../../../modules/ssm-parameter | n/a |
| <a name="module_prometheus"></a> [prometheus](#module\_prometheus) | ../../../modules/eks-monitoring | n/a |
| <a name="module_prometheus_service_account_role"></a> [prometheus\_service\_account\_role](#module\_prometheus\_service\_account\_role) | ../../../modules/iam-role | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |
| <a name="module_web_identity_iam_role"></a> [web\_identity\_iam\_role](#module\_web\_identity\_iam\_role) | ../../../modules/iam-role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy_attachment.cloudwatch_role_attachment](https://registry.terraform.io/providers/aws/5.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.prometheus_managed_role_attachment](https://registry.terraform.io/providers/aws/5.4.0/docs/resources/iam_role_policy_attachment) | resource |
| [helm_release.grafana](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [helm_release.kuberhealthy](https://registry.terraform.io/providers/helm/latest/docs/resources/release) | resource |
| [local_file.grafana_gateway](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.grafana_virtual_service](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.apply_manifests](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster_auth](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.grafana_eks_policy](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.prometheus_sa_policy](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/aws/5.4.0/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name | `string` | `"arc-saas.net"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_grafana_admin_username"></a> [grafana\_admin\_username](#input\_grafana\_admin\_username) | Grafana admin login username | `string` | `"adminuser"` | no |
| <a name="input_grafana_helm_release_version"></a> [grafana\_helm\_release\_version](#input\_grafana\_helm\_release\_version) | Grafana helm release version | `string` | `"7.3.0"` | no |
| <a name="input_grafana_namespace"></a> [grafana\_namespace](#input\_grafana\_namespace) | grafana namespace in which grafna will be deployed | `string` | `"grafana"` | no |
| <a name="input_grafana_service_type"></a> [grafana\_service\_type](#input\_grafana\_service\_type) | Grafana Service type Loadbalancer in our type | `string` | `"Loadbalancer"` | no |
| <a name="input_grafana_volume_size"></a> [grafana\_volume\_size](#input\_grafana\_volume\_size) | Grafana persistant volume size | `string` | `"10Gi"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Service Account Name | `string` | `"grafana"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_prometheus_workspace_endpoint"></a> [managed\_prometheus\_workspace\_endpoint](#output\_managed\_prometheus\_workspace\_endpoint) | Amazon managed workspace endpoint |
| <a name="output_managed_prometheus_workspace_id"></a> [managed\_prometheus\_workspace\_id](#output\_managed\_prometheus\_workspace\_id) | Amazon Managed Workspace ID |
<!-- END_TF_DOCS -->