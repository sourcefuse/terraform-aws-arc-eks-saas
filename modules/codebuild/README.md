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
| [aws_codebuild_project.codebuild_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.authorization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_artifact_location"></a> [artifact\_location](#input\_artifact\_location) | Location of artifact. Applies only for artifact of type S3 | `string` | `""` | no |
| <a name="input_artifact_type"></a> [artifact\_type](#input\_artifact\_type) | The build output artifact's type. Valid values for this parameter are: CODEPIPELINE, NO\_ARTIFACTS or S3 | `string` | `"NO_ARTIFACTS"` | no |
| <a name="input_badge_enabled"></a> [badge\_enabled](#input\_badge\_enabled) | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled | `bool` | `false` | no |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | Instance type of the build instance e.g. UILD\_GENERAL1\_SMALL, BUILD\_GENERAL1\_MEDIUM, BUILD\_GENERAL1\_LARGE, BUILD\_GENERAL1\_2XLARGE | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Docker image for build environment, e.g. 'aws/codebuild/standard:2.0' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html | `string` | `"aws/codebuild/standard:2.0"` | no |
| <a name="input_build_image_pull_credentials_type"></a> [build\_image\_pull\_credentials\_type](#input\_build\_image\_pull\_credentials\_type) | Type of credentials AWS CodeBuild uses to pull images in your build.Valid values: CODEBUILD, SERVICE\_ROLE. When you use a cross-account or private registry image, you must use SERVICE\_ROLE credentials. | `string` | `"CODEBUILD"` | no |
| <a name="input_build_timeout"></a> [build\_timeout](#input\_build\_timeout) | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `60` | no |
| <a name="input_build_type"></a> [build\_type](#input\_build\_type) | The type of build environment, e.g. LINUX\_CONTAINER, LINUX\_GPU\_CONTAINER, WINDOWS\_CONTAINER, WINDOWS\_SERVER\_2019\_CONTAINER, ARM\_CONTAINER, LINUX\_LAMBDA\_CONTAINER, ARM\_LAMBDA\_CONTAINER | `string` | `"LINUX_CONTAINER"` | no |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Optional buildspec declaration to use for building the project | `string` | `""` | no |
| <a name="input_cache_location"></a> [cache\_location](#input\_cache\_location) | Required when cache type is S3. Location where the AWS CodeBuild project stores cached resources. For type S3, the value must be a valid S3 bucket name/prefix. | `string` | `""` | no |
| <a name="input_cache_mode"></a> [cache\_mode](#input\_cache\_mode) | Required when cache type is LOCAL. Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Valid values: LOCAL\_SOURCE\_CACHE, LOCAL\_DOCKER\_LAYER\_CACHE, LOCAL\_CUSTOM\_CACHE | `list(string)` | `[]` | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to NO\_CACHE.  If cache\_type is S3, it will create an S3 bucket for storing codebuild cache inside | `string` | `"NO_CACHE"` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | Group name of the logs in CloudWatch Logs | `string` | `"codebuild-log-group"` | no |
| <a name="input_cloudwatch_log_status"></a> [cloudwatch\_log\_status](#input\_cloudwatch\_log\_status) | Current status of logs in CloudWatch Logs for a build project. Valid values: ENABLED, DISABLED. Defaults to ENABLED | `string` | `"ENABLED"` | no |
| <a name="input_cloudwatch_log_stream_name"></a> [cloudwatch\_log\_stream\_name](#input\_cloudwatch\_log\_stream\_name) | Stream name of the logs in CloudWatch Logs. | `string` | `"log-stream"` | no |
| <a name="input_concurrent_build_limit"></a> [concurrent\_build\_limit](#input\_concurrent\_build\_limit) | Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit. | `number` | `1` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of Codebuild Project | `string` | `"my-codebuild-project"` | no |
| <a name="input_enable_codebuild_authentication"></a> [enable\_codebuild\_authentication](#input\_enable\_codebuild\_authentication) | Enable codebuild authentication | `bool` | `false` | no |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project build output artifacts | `string` | `""` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain the keys 'name', 'value', and 'type' to be used as additional environment variables for the build. Valid types are 'PLAINTEXT', 'PARAMETER\_STORE', or 'SECRETS\_MANAGER' | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>      type  = string<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_fetch_submodules"></a> [fetch\_submodules](#input\_fetch\_submodules) | If set to true, fetches Git submodules for the AWS CodeBuild build project. | `bool` | `false` | no |
| <a name="input_git_clone_depth"></a> [git\_clone\_depth](#input\_git\_clone\_depth) | Truncate git history to this many commits. Use 0 for Full | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | CodeBuild Project Name | `string` | `"my-codebuild-project"` | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `true` | no |
| <a name="input_queued_timeout"></a> [queued\_timeout](#input\_queued\_timeout) | Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours. | `number` | `8` | no |
| <a name="input_report_build_status"></a> [report\_build\_status](#input\_report\_build\_status) | Set to true to report the status of a build's start and finish to your source provider. This option is only valid when the source\_type is BITBUCKET or GITHUB | `bool` | `false` | no |
| <a name="input_s3_log_location"></a> [s3\_log\_location](#input\_s3\_log\_location) | Name of the S3 bucket and the path prefix for S3 logs. Must be set if status is ENABLED, otherwise it must be empty | `string` | `""` | no |
| <a name="input_s3_log_status"></a> [s3\_log\_status](#input\_s3\_log\_status) | Current status of logs in S3 Logs for a build project. Valid values: ENABLED, DISABLED. Defaults to ENABLED | `string` | `"DISABLED"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group IDs to assign to running builds. | `list(string)` | `[]` | no |
| <a name="input_service_role"></a> [service\_role](#input\_service\_role) | CodeBuild IAM Service Role | `string` | `""` | no |
| <a name="input_source_credential_auth_type"></a> [source\_credential\_auth\_type](#input\_source\_credential\_auth\_type) | The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository. value can be PERSONAL\_ACCESS\_TOKEN or BASIC\_AUTH | `string` | `"PERSONAL_ACCESS_TOKEN"` | no |
| <a name="input_source_credential_server_type"></a> [source\_credential\_server\_type](#input\_source\_credential\_server\_type) | The source provider used for this project. | `string` | `"GITHUB"` | no |
| <a name="input_source_credential_token"></a> [source\_credential\_token](#input\_source\_credential\_token) | For GitHub or GitHub Enterprise, this is the personal access token. For Bitbucket, this is the app password. | `string` | `""` | no |
| <a name="input_source_credential_user_name"></a> [source\_credential\_user\_name](#input\_source\_credential\_user\_name) | The Bitbucket username when the authType is BASIC\_AUTH. This parameter is not valid for other types of source providers or connections. | `string` | `""` | no |
| <a name="input_source_location"></a> [source\_location](#input\_source\_location) | The location of the source code from git or s3 | `string` | `""` | no |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB\_ENTERPRISE, BITBUCKET or S3 | `string` | `"GITHUB"` | no |
| <a name="input_source_version"></a> [source\_version](#input\_source\_version) | A version of the build input to be built for this project. If not specified, the latest version is used. | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet IDs within which to run builds. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign the security groups. | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC within which to run builds. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_badge_url"></a> [badge\_url](#output\_badge\_url) | The URL of the build badge when badge\_enabled is enabled |
| <a name="output_name"></a> [name](#output\_name) | Project name |
| <a name="output_project_arn"></a> [project\_arn](#output\_project\_arn) | Project ARN |
<!-- END_TF_DOCS -->