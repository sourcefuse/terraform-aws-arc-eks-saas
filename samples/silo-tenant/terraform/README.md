<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | 2.2.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | 1.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_opensearch"></a> [opensearch](#provider\_opensearch) | 2.2.0 |
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | 1.12.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | sourcefuse/arc-db/aws | 2.0.3 |
| <a name="module_aws_cognito_user_pool"></a> [aws\_cognito\_user\_pool](#module\_aws\_cognito\_user\_pool) | lgallard/cognito-user-pool/aws | 0.24.0 |
| <a name="module_cognito_domain_string"></a> [cognito\_domain\_string](#module\_cognito\_domain\_string) | ../modules/random-password | n/a |
| <a name="module_cognito_password"></a> [cognito\_password](#module\_cognito\_password) | ../modules/random-password | n/a |
| <a name="module_cognito_ssm_parameters"></a> [cognito\_ssm\_parameters](#module\_cognito\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_db_password"></a> [db\_password](#module\_db\_password) | ../modules/random-password | n/a |
| <a name="module_db_ssm_parameters"></a> [db\_ssm\_parameters](#module\_db\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_ec_security_group"></a> [ec\_security\_group](#module\_ec\_security\_group) | ../modules/security-group | n/a |
| <a name="module_jwt_secret"></a> [jwt\_secret](#module\_jwt\_secret) | ../modules/random-password | n/a |
| <a name="module_jwt_ssm_parameters"></a> [jwt\_ssm\_parameters](#module\_jwt\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | cloudposse/elasticache-redis/aws | 1.2.0 |
| <a name="module_redis_ssm_parameters"></a> [redis\_ssm\_parameters](#module\_redis\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_route53-record"></a> [route53-record](#module\_route53-record) | clouddrove/route53-record/aws | 1.0.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.5 |
| <a name="module_tenant_iam_role"></a> [tenant\_iam\_role](#module\_tenant\_iam\_role) | ../modules/iam-role | n/a |
| <a name="module_tenant_opensearch_parameters"></a> [tenant\_opensearch\_parameters](#module\_tenant\_opensearch\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_tenant_opensearch_password"></a> [tenant\_opensearch\_password](#module\_tenant\_opensearch\_password) | ../modules/random-password | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cognito_user.cognito_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user) | resource |
| [aws_security_group_rule.additional_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_synthetics_canary.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary) | resource |
| [kubernetes_namespace.my_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [local_file.argo_workflow](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.argocd_application](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.helm_values](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [opensearch_dashboard_object.test_index_pattern_v7](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/dashboard_object) | resource |
| [opensearch_role.tenant_index_role](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/role) | resource |
| [opensearch_roles_mapping.user_role_mapping](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/roles_mapping) | resource |
| [opensearch_roles_mapping.user_role_mapping1](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/roles_mapping) | resource |
| [opensearch_roles_mapping.user_role_mapping2](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/roles_mapping) | resource |
| [opensearch_user.tenant_user](https://registry.terraform.io/providers/opensearch-project/opensearch/2.2.0/docs/resources/user) | resource |
| [postgresql_database.audit_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [postgresql_database.authentication_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [postgresql_database.notification_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [postgresql_database.user_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [archive_file.canary_zip_inline](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.EKScluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.EKScluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_groups.aurora](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
| [aws_ssm_parameter.auditdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.authenticationdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_report_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.canary_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cognito_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cognito_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.cognito_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
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
| <a name="input_additional_inbound_rules"></a> [additional\_inbound\_rules](#input\_additional\_inbound\_rules) | n/a | <pre>list(object({<br>    description       = string<br>    from_port         = number<br>    to_port           = number<br>    protocol          = string<br>    cidr_blocks       = list(string)<br>    security_group_id = optional(list(string))<br>    ipv6_cidr_blocks  = optional(list(string))<br><br>  }))</pre> | `[]` | no |
| <a name="input_admin_create_user_config"></a> [admin\_create\_user\_config](#input\_admin\_create\_user\_config) | The configuration for AdminCreateUser requests | `map(any)` | <pre>{<br>  "email_message": "Dear {username}, your temporary password is {####}.",<br>  "email_subject": "Here, your temporary password",<br>  "sms_message": "Your username is {username} and temporary password is {####}."<br>}</pre> | no |
| <a name="input_admin_create_user_config_allow_admin_create_user_only"></a> [admin\_create\_user\_config\_allow\_admin\_create\_user\_only](#input\_admin\_create\_user\_config\_allow\_admin\_create\_user\_only) | Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app | `bool` | `false` | no |
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | Alarm action list | `list(string)` | `[]` | no |
| <a name="input_alarm_cpu_threshold_percent"></a> [alarm\_cpu\_threshold\_percent](#input\_alarm\_cpu\_threshold\_percent) | CPU threshold alarm level | `number` | `75` | no |
| <a name="input_alarm_memory_threshold_bytes"></a> [alarm\_memory\_threshold\_bytes](#input\_alarm\_memory\_threshold\_bytes) | Ram threshold alarm level | `number` | `10000000` | no |
| <a name="input_alb_url"></a> [alb\_url](#input\_alb\_url) | ALB DNS Record | `string` | n/a | yes |
| <a name="input_alias_attributes"></a> [alias\_attributes](#input\_alias\_attributes) | Attributes supported as an alias for this user pool. Possible values: phone\_number, email, or preferred\_username. Conflicts with `username_attributes` | `list(string)` | <pre>[<br>  "email",<br>  "phone_number",<br>  "preferred_username"<br>]</pre> | no |
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | The path for the API call , ex: /path?param=value. | `string` | `"/main/home"` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply changes immediately | `bool` | `true` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Enable encryption at rest | `bool` | `false` | no |
| <a name="input_auditdbdatabase"></a> [auditdbdatabase](#input\_auditdbdatabase) | ################################################################################# # Postgres DBs ################################################################################# | `string` | `"audit"` | no |
| <a name="input_aurora_allow_major_version_upgrade"></a> [aurora\_allow\_major\_version\_upgrade](#input\_aurora\_allow\_major\_version\_upgrade) | Enable to allow major engine version upgrades when changing engine versions. Defaults to false. | `bool` | `false` | no |
| <a name="input_aurora_auto_minor_version_upgrade"></a> [aurora\_auto\_minor\_version\_upgrade](#input\_aurora\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_aurora_cluster_enabled"></a> [aurora\_cluster\_enabled](#input\_aurora\_cluster\_enabled) | Enable creation of an Aurora Cluster | `bool` | `true` | no |
| <a name="input_aurora_cluster_family"></a> [aurora\_cluster\_family](#input\_aurora\_cluster\_family) | The family of the DB cluster parameter group | `string` | `"aurora-postgresql15"` | no |
| <a name="input_aurora_cluster_size"></a> [aurora\_cluster\_size](#input\_aurora\_cluster\_size) | Number of DB instances to create in the cluster | `number` | `1` | no |
| <a name="input_aurora_db_name"></a> [aurora\_db\_name](#input\_aurora\_db\_name) | Database name. | `string` | `"auroradb"` | no |
| <a name="input_aurora_db_port"></a> [aurora\_db\_port](#input\_aurora\_db\_port) | Port for the Aurora DB instance to use. | `number` | `5432` | no |
| <a name="input_aurora_engine"></a> [aurora\_engine](#input\_aurora\_engine) | The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql` | `string` | `"aurora-postgresql"` | no |
| <a name="input_aurora_engine_mode"></a> [aurora\_engine\_mode](#input\_aurora\_engine\_mode) | The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless` | `string` | `"provisioned"` | no |
| <a name="input_aurora_engine_version"></a> [aurora\_engine\_version](#input\_aurora\_engine\_version) | The version of the database engine tocl use. See `aws rds describe-db-engine-versions` | `string` | `"15.4"` | no |
| <a name="input_aurora_instance_type"></a> [aurora\_instance\_type](#input\_aurora\_instance\_type) | Instance type to use | `string` | `"db.t3.medium"` | no |
| <a name="input_aurora_iops"></a> [aurora\_iops](#input\_aurora\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of 'io1'. This setting is required to create a Multi-AZ DB cluster. Check TF docs for values based on db engine | `number` | `null` | no |
| <a name="input_aurora_serverlessv2_scaling_configuration"></a> [aurora\_serverlessv2\_scaling\_configuration](#input\_aurora\_serverlessv2\_scaling\_configuration) | serverlessv2 scaling properties | <pre>object({<br>    min_capacity = number<br>    max_capacity = number<br>  })</pre> | `null` | no |
| <a name="input_aurora_storage_type"></a> [aurora\_storage\_type](#input\_aurora\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD) or aurora-iopt1 | `string` | `"aurora-iopt1"` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars | `string` | `null` | no |
| <a name="input_authenticationdbdatabase"></a> [authenticationdbdatabase](#input\_authenticationdbdatabase) | n/a | `string` | `"auth"` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported if the engine version is 6 or higher. | `bool` | `true` | no |
| <a name="input_auto_verified_attributes"></a> [auto\_verified\_attributes](#input\_auto\_verified\_attributes) | The attributes to be auto-verified. Possible values: email, phone\_number | `list(string)` | <pre>[<br>  "email"<br>]</pre> | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Automatic failover (Not available for T1/T2 instances) | `bool` | `false` | no |
| <a name="input_canary_enabled"></a> [canary\_enabled](#input\_canary\_enabled) | To determine whether to create canary run or not | `bool` | `true` | no |
| <a name="input_client_prevent_user_existence_errors"></a> [client\_prevent\_user\_existence\_errors](#input\_client\_prevent\_user\_existence\_errors) | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool. | `string` | `"ENABLED"` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | A container with the clients definitions | `any` | `[]` | no |
| <a name="input_cloudwatch_metric_alarms_enabled"></a> [cloudwatch\_metric\_alarms\_enabled](#input\_cloudwatch\_metric\_alarms\_enabled) | Boolean flag to enable/disable CloudWatch metrics alarms | `bool` | `false` | no |
| <a name="input_cluster_mode_enabled"></a> [cluster\_mode\_enabled](#input\_cluster\_mode\_enabled) | Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `false` | no |
| <a name="input_cluster_mode_num_node_groups"></a> [cluster\_mode\_num\_node\_groups](#input\_cluster\_mode\_num\_node\_groups) | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications | `number` | `0` | no |
| <a name="input_cluster_mode_replicas_per_node_group"></a> [cluster\_mode\_replicas\_per\_node\_group](#input\_cluster\_mode\_replicas\_per\_node\_group) | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`* | `number` | `1` | no |
| <a name="input_cognito_deletion_protection"></a> [cognito\_deletion\_protection](#input\_cognito\_deletion\_protection) | When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature. Valid values are `ACTIVE` and `INACTIVE`. | `string` | `"INACTIVE"` | no |
| <a name="input_create_parameter_group"></a> [create\_parameter\_group](#input\_create\_parameter\_group) | Whether new parameter group should be created. Set to false if you want to use existing parameter group | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Protect the instance from being deleted | `bool` | `false` | no |
| <a name="input_device_configuration"></a> [device\_configuration](#input\_device\_configuration) | The configuration for the user pool's device tracking | `map(any)` | <pre>{<br>  "challenge_required_on_new_device": true,<br>  "device_only_remembered_on_user_prompt": true<br>}</pre> | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Enter Defeault Redirect URL | `string` | `""` | no |
| <a name="input_email_configuration"></a> [email\_configuration](#input\_email\_configuration) | The Email Configuration | `map(any)` | <pre>{<br>  "email_sending_account": "COGNITO_DEFAULT",<br>  "reply_to_email_address": "",<br>  "source_arn": ""<br>}</pre> | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Redis engine version | `string` | `"6.2"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | Redis family | `string` | `"redis6.x"` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | `false` | no |
| <a name="input_identity_providers"></a> [identity\_providers](#input\_identity\_providers) | Cognito Pool Identity Providers | `list(any)` | `[]` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Elastic cache instance type | `string` | `"cache.t3.small"` | no |
| <a name="input_jwt_issuer"></a> [jwt\_issuer](#input\_jwt\_issuer) | jwt issuer | `string` | n/a | yes |
| <a name="input_karpenter_role"></a> [karpenter\_role](#input\_karpenter\_role) | EKS Karpenter Role | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window | `string` | `"sun:03:00-sun:04:00"` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL) | `string` | `"OFF"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored) | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_notificationdbdatabase"></a> [notificationdbdatabase](#input\_notificationdbdatabase) | n/a | `string` | `"notification"` | no |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN) | `list(string)` | `[]` | no |
| <a name="input_parameter"></a> [parameter](#input\_parameter) | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | A container for information about the user pool password policy | <pre>object({<br>    minimum_length                   = number,<br>    require_lowercase                = bool,<br>    require_numbers                  = bool,<br>    require_symbols                  = bool,<br>    require_uppercase                = bool,<br>    temporary_password_validity_days = number<br>  })</pre> | <pre>{<br>  "minimum_length": 10,<br>  "require_lowercase": true,<br>  "require_numbers": true,<br>  "require_symbols": true,<br>  "require_uppercase": true,<br>  "temporary_password_validity_days": 7<br>}</pre> | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Whether to enable Performance Insights | `bool` | `true` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years) | `number` | `7` | no |
| <a name="input_recovery_mechanisms"></a> [recovery\_mechanisms](#input\_recovery\_mechanisms) | The list of Account Recovery Options | `list(any)` | `[]` | no |
| <a name="input_redis_database"></a> [redis\_database](#input\_redis\_database) | Redis Database | `string` | `"0"` | no |
| <a name="input_redis_port"></a> [redis\_port](#input\_redis\_port) | Redis Port | `number` | `6379` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_resource_servers"></a> [resource\_servers](#input\_resource\_servers) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Runtime version of the canary. Details: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Library_nodejs_puppeteer.html | `string` | `"syn-nodejs-puppeteer-7.0"` | no |
| <a name="input_sms_authentication_message"></a> [sms\_authentication\_message](#input\_sms\_authentication\_message) | A string representing the SMS authentication message | `string` | `"Your username is {username} and temporary password is {####}."` | no |
| <a name="input_sms_verification_message"></a> [sms\_verification\_message](#input\_sms\_verification\_message) | A string representing the SMS verification message | `string` | `"This is the verification message {####}."` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `number` | `0` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"06:30-07:30"` | no |
| <a name="input_software_token_mfa_configuration"></a> [software\_token\_mfa\_configuration](#input\_software\_token\_mfa\_configuration) | Configuration block for software token MFA (multifactor-auth). mfa\_configuration must also be enabled for this to work | `map(any)` | `{}` | no |
| <a name="input_software_token_mfa_configuration_enabled"></a> [software\_token\_mfa\_configuration\_enabled](#input\_software\_token\_mfa\_configuration\_enabled) | If true, and if mfa\_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled | `bool` | `true` | no |
| <a name="input_take_screenshot"></a> [take\_screenshot](#input\_take\_screenshot) | If screenshot should be taken | `bool` | `false` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | tenant name | `string` | n/a | yes |
| <a name="input_tenant_client_id"></a> [tenant\_client\_id](#input\_tenant\_client\_id) | tenant Client ID | `string` | n/a | yes |
| <a name="input_tenant_client_secret"></a> [tenant\_client\_secret](#input\_tenant\_client\_secret) | tenant Client Secret | `string` | n/a | yes |
| <a name="input_tenant_email"></a> [tenant\_email](#input\_tenant\_email) | tenant Email | `string` | n/a | yes |
| <a name="input_tenant_host_domain"></a> [tenant\_host\_domain](#input\_tenant\_host\_domain) | tenant Host | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenat unique ID | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | Tenant Name | `string` | n/a | yes |
| <a name="input_tenant_secret"></a> [tenant\_secret](#input\_tenant\_secret) | tenant secret | `string` | n/a | yes |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | A list of DB timeouts to apply to the running code while creating, updating, or deleting the DB instance. | <pre>object({<br>    create = string<br>    update = string<br>    delete = string<br>  })</pre> | <pre>{<br>  "create": "40m",<br>  "delete": "60m",<br>  "update": "80m"<br>}</pre> | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.<br>If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis. | `bool` | `false` | no |
| <a name="input_user_callback_secret"></a> [user\_callback\_secret](#input\_user\_callback\_secret) | Secret for user tenant service | `string` | n/a | yes |
| <a name="input_user_groups"></a> [user\_groups](#input\_user\_groups) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | cognito user | `string` | n/a | yes |
| <a name="input_user_pool_add_ons_advanced_security_mode"></a> [user\_pool\_add\_ons\_advanced\_security\_mode](#input\_user\_pool\_add\_ons\_advanced\_security\_mode) | The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED` | `string` | `"OFF"` | no |
| <a name="input_userdbdatabase"></a> [userdbdatabase](#input\_userdbdatabase) | n/a | `string` | `"user"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->