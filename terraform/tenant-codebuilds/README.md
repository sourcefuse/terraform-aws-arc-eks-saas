<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_basic_plan_codebuild_project"></a> [basic\_plan\_codebuild\_project](#module\_basic\_plan\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_bridge_tenant_client_id"></a> [bridge\_tenant\_client\_id](#module\_bridge\_tenant\_client\_id) | ../../modules/random-password | n/a |
| <a name="module_bridge_tenant_client_secret"></a> [bridge\_tenant\_client\_secret](#module\_bridge\_tenant\_client\_secret) | ../../modules/random-password | n/a |
| <a name="module_pooled_tenant_client_id"></a> [pooled\_tenant\_client\_id](#module\_pooled\_tenant\_client\_id) | ../../modules/random-password | n/a |
| <a name="module_pooled_tenant_client_secret"></a> [pooled\_tenant\_client\_secret](#module\_pooled\_tenant\_client\_secret) | ../../modules/random-password | n/a |
| <a name="module_premium_offboard_codebuild_project"></a> [premium\_offboard\_codebuild\_project](#module\_premium\_offboard\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_premium_plan_codebuild_project"></a> [premium\_plan\_codebuild\_project](#module\_premium\_plan\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_saas_management_github_repository"></a> [saas\_management\_github\_repository](#module\_saas\_management\_github\_repository) | ../../modules/github | n/a |
| <a name="module_silo_tenant_client_id"></a> [silo\_tenant\_client\_id](#module\_silo\_tenant\_client\_id) | ../../modules/random-password | n/a |
| <a name="module_silo_tenant_client_secret"></a> [silo\_tenant\_client\_secret](#module\_silo\_tenant\_client\_secret) | ../../modules/random-password | n/a |
| <a name="module_standard_plan_codebuild_project"></a> [standard\_plan\_codebuild\_project](#module\_standard\_plan\_codebuild\_project) | ../../modules/codebuild | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |
| <a name="module_tenant_codebuild_iam_role"></a> [tenant\_codebuild\_iam\_role](#module\_tenant\_codebuild\_iam\_role) | ../../modules/iam-role | n/a |
| <a name="module_tenant_ssm_parameters"></a> [tenant\_ssm\_parameters](#module\_tenant\_ssm\_parameters) | ../../modules/ssm-parameter | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tenant_codebuild_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_security_groups.codebuild_db_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_ssm_parameter.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.karpenter_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.terraform_state_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_basic_buildspec"></a> [basic\_buildspec](#input\_basic\_buildspec) | Optional buildspec declaration to use for building the project | `string` | `""` | no |
| <a name="input_basic_cloudwatch_log_group_name"></a> [basic\_cloudwatch\_log\_group\_name](#input\_basic\_cloudwatch\_log\_group\_name) | Group name of the logs in CloudWatch Logs | `string` | `"basic-codebuild-log-group"` | no |
| <a name="input_basic_source_location"></a> [basic\_source\_location](#input\_basic\_source\_location) | The location of the source code from git or s3 | `string` | `""` | no |
| <a name="input_basic_source_version"></a> [basic\_source\_version](#input\_basic\_source\_version) | A version of the Basic build input to be built for this project. If not specified, the latest version is used. | `string` | `""` | no |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | Instance type of the build instance e.g. UILD\_GENERAL1\_SMALL, BUILD\_GENERAL1\_MEDIUM, BUILD\_GENERAL1\_LARGE, BUILD\_GENERAL1\_2XLARGE | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html | `string` | `"aws/codebuild/standard:7.0"` | no |
| <a name="input_build_image_pull_credentials_type"></a> [build\_image\_pull\_credentials\_type](#input\_build\_image\_pull\_credentials\_type) | Type of credentials AWS CodeBuild uses to pull images in your build.Valid values: CODEBUILD, SERVICE\_ROLE. When you use a cross-account or private registry image, you must use SERVICE\_ROLE credentials. | `string` | `"CODEBUILD"` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `120` | no |
| <a name="input_build_type"></a> [build\_type](#input\_build\_type) | The type of build environment, e.g. LINUX\_CONTAINER, LINUX\_GPU\_CONTAINER, WINDOWS\_CONTAINER, WINDOWS\_SERVER\_2019\_CONTAINER, ARM\_CONTAINER, LINUX\_LAMBDA\_CONTAINER, ARM\_LAMBDA\_CONTAINER | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_cloudwatch_log_stream_name"></a> [cloudwatch\_log\_stream\_name](#input\_cloudwatch\_log\_stream\_name) | Stream name of the logs in CloudWatch Logs. | `string` | `"log-stream"` | no |
| <a name="input_concurrent_build_limit"></a> [concurrent\_build\_limit](#input\_concurrent\_build\_limit) | Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit. | `number` | `1` | no |
| <a name="input_control_plane_host"></a> [control\_plane\_host](#input\_control\_plane\_host) | Host Name of the control plane | `string` | n/a | yes |
| <a name="input_create_basic_codebuild"></a> [create\_basic\_codebuild](#input\_create\_basic\_codebuild) | Enable or Disable to create basic codebuild project | `bool` | `true` | no |
| <a name="input_create_premium_codebuild"></a> [create\_premium\_codebuild](#input\_create\_premium\_codebuild) | Enable or Disable to create premium codebuild project | `bool` | `true` | no |
| <a name="input_create_premium_offboard_codebuild"></a> [create\_premium\_offboard\_codebuild](#input\_create\_premium\_offboard\_codebuild) | Enable or Disable to create premium offboarding codebuild project | `bool` | `true` | no |
| <a name="input_create_standard_codebuild"></a> [create\_standard\_codebuild](#input\_create\_standard\_codebuild) | Enable or Disable to create standard codebuild project | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name of the control plane | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_is_organization"></a> [is\_organization](#input\_is\_organization) | Enable or Disable based on if github repository is part of organization or not | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | Github organization Name | `string` | `"sourcefuse"` | no |
| <a name="input_premium_buildspec"></a> [premium\_buildspec](#input\_premium\_buildspec) | Optional buildspec declaration to use for building the project | `string` | `""` | no |
| <a name="input_premium_cloudwatch_log_group_name"></a> [premium\_cloudwatch\_log\_group\_name](#input\_premium\_cloudwatch\_log\_group\_name) | Group name of the logs in CloudWatch Logs | `string` | `"premium-codebuild-log-group"` | no |
| <a name="input_premium_offboard_buildspec"></a> [premium\_offboard\_buildspec](#input\_premium\_offboard\_buildspec) | Optional buildspec declaration to use for building the project | `string` | `""` | no |
| <a name="input_premium_source_location"></a> [premium\_source\_location](#input\_premium\_source\_location) | The location of the source code from git or s3 | `string` | `""` | no |
| <a name="input_premium_source_version"></a> [premium\_source\_version](#input\_premium\_source\_version) | A version of the Premium build input to be built for this project. If not specified, the latest version is used. | `string` | `""` | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `true` | no |
| <a name="input_queued_timeout"></a> [queued\_timeout](#input\_queued\_timeout) | Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours. | `number` | `8` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB\_ENTERPRISE, BITBUCKET or S3 | `string` | `"GITHUB"` | no |
| <a name="input_standard_buildspec"></a> [standard\_buildspec](#input\_standard\_buildspec) | Optional buildspec declaration to use for building the project | `string` | `""` | no |
| <a name="input_standard_cloudwatch_log_group_name"></a> [standard\_cloudwatch\_log\_group\_name](#input\_standard\_cloudwatch\_log\_group\_name) | Group name of the logs in CloudWatch Logs | `string` | `"standard-codebuild-log-group"` | no |
| <a name="input_standard_source_location"></a> [standard\_source\_location](#input\_standard\_source\_location) | The location of the source code from git or s3 | `string` | `""` | no |
| <a name="input_standard_source_version"></a> [standard\_source\_version](#input\_standard\_source\_version) | A version of the Standard build input to be built for this project. If not specified, the latest version is used. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->