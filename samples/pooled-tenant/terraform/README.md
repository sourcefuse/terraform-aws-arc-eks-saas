<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | = 2.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | 2.2.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | 1.20.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | = 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_opensearch"></a> [opensearch](#provider\_opensearch) | 2.2.0 |
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | 1.20.2 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cognito_password"></a> [cognito\_password](#module\_cognito\_password) | ../modules/random-password | n/a |
| <a name="module_cognito_ssm_parameters"></a> [cognito\_ssm\_parameters](#module\_cognito\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_db_ssm_parameters"></a> [db\_ssm\_parameters](#module\_db\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_jwt_secret"></a> [jwt\_secret](#module\_jwt\_secret) | ../modules/random-password | n/a |
| <a name="module_jwt_ssm_parameters"></a> [jwt\_ssm\_parameters](#module\_jwt\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_route53-record"></a> [route53-record](#module\_route53-record) | clouddrove/route53-record/aws | 1.0.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |
| <a name="module_tenant_db_password"></a> [tenant\_db\_password](#module\_tenant\_db\_password) | ../modules/random-password | n/a |
| <a name="module_tenant_iam_role"></a> [tenant\_iam\_role](#module\_tenant\_iam\_role) | ../modules/iam-role | n/a |
| <a name="module_tenant_opensearch_parameters"></a> [tenant\_opensearch\_parameters](#module\_tenant\_opensearch\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_tenant_opensearch_password"></a> [tenant\_opensearch\_password](#module\_tenant\_opensearch\_password) | ../modules/random-password | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cognito_user.cognito_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user) | resource |
| [aws_cognito_user_pool_client.app_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_synthetics_canary.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [kubernetes_namespace.my_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [local_file.argo_workflow](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.argocd_application](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.helm_values](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.pooled_argo_workflow](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [opensearch_dashboard_object.test_index_pattern_v7](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/dashboard_object) | resource |
| [opensearch_role.tenant_index_role](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/role) | resource |
| [opensearch_roles_mapping.user_role_mapping](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/roles_mapping) | resource |
| [opensearch_roles_mapping.user_role_mapping1](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/roles_mapping) | resource |
| [opensearch_roles_mapping.user_role_mapping2](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/roles_mapping) | resource |
| [opensearch_user.tenant_user](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/user) | resource |
| [postgresql_role.db_user](https://registry.terraform.io/providers/ricochet1k/postgresql/1.20.2/docs/resources/role) | resource |
| [random_id.uuid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [archive_file.canary_zip_inline](https://registry.terraform.io/providers/hashicorp/archive/2.2.0/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.EKScluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.EKScluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_ssm_parameter.auditdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.authenticationdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_report_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cognito_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cognito_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cognito_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cognito_user_pool_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_schema](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.db_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.jwt_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.jwt_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.notificationdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.opensearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.opensearch_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.opensearch_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.productdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.redis_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.redis_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.redis_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.userdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.helm_values_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_url"></a> [alb\_url](#input\_alb\_url) | ALB DNS Record | `string` | n/a | yes |
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | The path for the API call , ex: /path?param=value. | `string` | `"/main/home"` | no |
| <a name="input_canary_enabled"></a> [canary\_enabled](#input\_canary\_enabled) | To determine whether to create canary run or not | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Enter Defeault Redirect URL | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_jwt_issuer"></a> [jwt\_issuer](#input\_jwt\_issuer) | jwt issuer | `string` | n/a | yes |
| <a name="input_karpenter_role"></a> [karpenter\_role](#input\_karpenter\_role) | EKS Karpenter Role | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Runtime version of the canary. Details: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Library_nodejs_puppeteer.html | `string` | `"syn-nodejs-puppeteer-7.0"` | no |
| <a name="input_take_screenshot"></a> [take\_screenshot](#input\_take\_screenshot) | If screenshot should be taken | `bool` | `false` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | tenant name | `string` | n/a | yes |
| <a name="input_tenant_client_id"></a> [tenant\_client\_id](#input\_tenant\_client\_id) | tenant Client ID | `string` | n/a | yes |
| <a name="input_tenant_client_secret"></a> [tenant\_client\_secret](#input\_tenant\_client\_secret) | tenant Client Secret | `string` | n/a | yes |
| <a name="input_tenant_email"></a> [tenant\_email](#input\_tenant\_email) | tenant Email | `string` | n/a | yes |
| <a name="input_tenant_host_domain"></a> [tenant\_host\_domain](#input\_tenant\_host\_domain) | tenant Host | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenat unique ID | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | Tenant Name | `string` | n/a | yes |
| <a name="input_tenant_secret"></a> [tenant\_secret](#input\_tenant\_secret) | tenant secret | `string` | n/a | yes |
| <a name="input_user_callback_secret"></a> [user\_callback\_secret](#input\_user\_callback\_secret) | Secret for user tenant service | `string` | n/a | yes |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | cognito user | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->