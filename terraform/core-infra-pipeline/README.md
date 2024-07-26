<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_billing_module_build_step_codebuild_project"></a> [billing\_module\_build\_step\_codebuild\_project](#module\_billing\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_billing_module_build_step_role"></a> [billing\_module\_build\_step\_role](#module\_billing\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_bootstrap_role"></a> [bootstrap\_role](#module\_bootstrap\_role) | ../../modules/iam-role | n/a |
| <a name="module_codepipeline_role"></a> [codepipeline\_role](#module\_codepipeline\_role) | ../../modules/iam-role | n/a |
| <a name="module_cognito_module_build_step_codebuild_project"></a> [cognito\_module\_build\_step\_codebuild\_project](#module\_cognito\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_cognito_module_build_step_role"></a> [cognito\_module\_build\_step\_role](#module\_cognito\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_control_plane_module_build_step_codebuild_project"></a> [control\_plane\_module\_build\_step\_codebuild\_project](#module\_control\_plane\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_control_plane_module_build_step_role"></a> [control\_plane\_module\_build\_step\_role](#module\_control\_plane\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_decoupling_module_build_step_codebuild_project"></a> [decoupling\_module\_build\_step\_codebuild\_project](#module\_decoupling\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_decoupling_module_build_step_role"></a> [decoupling\_module\_build\_step\_role](#module\_decoupling\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_deployment_pipeline"></a> [deployment\_pipeline](#module\_deployment\_pipeline) | ../../modules/codepipeline | n/a |
| <a name="module_eks_auth_module_build_step_codebuild_project"></a> [eks\_auth\_module\_build\_step\_codebuild\_project](#module\_eks\_auth\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_eks_auth_module_build_step_role"></a> [eks\_auth\_module\_build\_step\_role](#module\_eks\_auth\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_eks_module_build_step_codebuild_project"></a> [eks\_module\_build\_step\_codebuild\_project](#module\_eks\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_eks_module_build_step_role"></a> [eks\_module\_build\_step\_role](#module\_eks\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_eks_observability_module_build_step_codebuild_project"></a> [eks\_observability\_module\_build\_step\_codebuild\_project](#module\_eks\_observability\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_eks_observability_module_build_step_role"></a> [eks\_observability\_module\_build\_step\_role](#module\_eks\_observability\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_elasticache_module_build_step_codebuild_project"></a> [elasticache\_module\_build\_step\_codebuild\_project](#module\_elasticache\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_elasticache_module_build_step_role"></a> [elasticache\_module\_build\_step\_role](#module\_elasticache\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_iam_role_build_step_role"></a> [iam\_role\_build\_step\_role](#module\_iam\_role\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_iam_role_module_build_step_codebuild_project"></a> [iam\_role\_module\_build\_step\_codebuild\_project](#module\_iam\_role\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_initial_bootstrap"></a> [initial\_bootstrap](#module\_initial\_bootstrap) | ../../modules/codebuild | n/a |
| <a name="module_istio_module_build_step_codebuild_project"></a> [istio\_module\_build\_step\_codebuild\_project](#module\_istio\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_istio_module_build_step_role"></a> [istio\_module\_build\_step\_role](#module\_istio\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_networking_module_build_step_codebuild_project"></a> [networking\_module\_build\_step\_codebuild\_project](#module\_networking\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_networking_module_build_step_role"></a> [networking\_module\_build\_step\_role](#module\_networking\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_opensearch_module_build_step_codebuild_project"></a> [opensearch\_module\_build\_step\_codebuild\_project](#module\_opensearch\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_opensearch_module_build_step_role"></a> [opensearch\_module\_build\_step\_role](#module\_opensearch\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_os_ops_module_build_step_role"></a> [os\_ops\_module\_build\_step\_role](#module\_os\_ops\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_rds_module_build_step_role"></a> [rds\_module\_build\_step\_role](#module\_rds\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |
| <a name="module_tenant_codebuild_module_build_step_codebuild_project"></a> [tenant\_codebuild\_module\_build\_step\_codebuild\_project](#module\_tenant\_codebuild\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_tenant_codebuild_module_build_step_role"></a> [tenant\_codebuild\_module\_build\_step\_role](#module\_tenant\_codebuild\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_vpn_module_build_step_codebuild_project"></a> [vpn\_module\_build\_step\_codebuild\_project](#module\_vpn\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_vpn_module_build_step_role"></a> [vpn\_module\_build\_step\_role](#module\_vpn\_module\_build\_step\_role) | ../../modules/iam-role | n/a |
| <a name="module_waf_module_build_step_codebuild_project"></a> [waf\_module\_build\_step\_codebuild\_project](#module\_waf\_module\_build\_step\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_waf_module_build_step_role"></a> [waf\_module\_build\_step\_role](#module\_waf\_module\_build\_step\_role) | ../../modules/iam-role | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_codebuild_project.os_ops_module_build_step_codebuild_project](https://registry.terraform.io/providers/hashicorp/aws/5.4.0/docs/resources/codebuild_project) | resource |
| [aws_codebuild_project.rds_module_build_step_codebuild_project](https://registry.terraform.io/providers/hashicorp/aws/5.4.0/docs/resources/codebuild_project) | resource |
| [aws_codestarconnections_connection.existing_github_connection](https://registry.terraform.io/providers/hashicorp/aws/5.4.0/docs/data-sources/codestarconnections_connection) | data source |
| [aws_iam_policy_document.resource_full_access](https://registry.terraform.io/providers/hashicorp/aws/5.4.0/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.artifact_bucket](https://registry.terraform.io/providers/hashicorp/aws/5.4.0/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `"dev"` | no |
| <a name="input_github_BranchName"></a> [github\_BranchName](#input\_github\_BranchName) | Github Branch Name | `string` | `"main"` | no |
| <a name="input_github_FullRepositoryId"></a> [github\_FullRepositoryId](#input\_github\_FullRepositoryId) | role name of the code pipeline | `string` | n/a | yes |
| <a name="input_github_connection_pipeline"></a> [github\_connection\_pipeline](#input\_github\_connection\_pipeline) | code star pipeline connect to the github repo | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | `"arc-saas"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->