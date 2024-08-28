<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | = 2.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_opensearch"></a> [opensearch](#requirement\_opensearch) | 2.2.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | 1.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | = 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_opensearch"></a> [opensearch](#provider\_opensearch) | 2.2.0 |
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | 1.12.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cognito_ssm_parameters"></a> [cognito\_ssm\_parameters](#module\_cognito\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_db_password"></a> [db\_password](#module\_db\_password) | ../modules/random-password | n/a |
| <a name="module_db_ssm_parameters"></a> [db\_ssm\_parameters](#module\_db\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_ec_security_group"></a> [ec\_security\_group](#module\_ec\_security\_group) | ../modules/security-group | n/a |
| <a name="module_jwt_secret"></a> [jwt\_secret](#module\_jwt\_secret) | ../modules/random-password | n/a |
| <a name="module_jwt_ssm_parameters"></a> [jwt\_ssm\_parameters](#module\_jwt\_ssm\_parameters) | ../modules/ssm-parameter | n/a |
| <a name="module_rds_postgres"></a> [rds\_postgres](#module\_rds\_postgres) | sourcefuse/arc-db/aws | 3.1.5 |
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
| [aws_cognito_user_pool_client.app_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_security_group_rule.additional_inbound_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
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
| [postgresql_database.authentication_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [postgresql_database.feature_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [postgresql_database.notification_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [postgresql_database.video_confrencing_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/1.12.0/docs/resources/database) | resource |
| [archive_file.canary_zip_inline](https://registry.terraform.io/providers/hashicorp/archive/2.2.0/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.EKScluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.EKScluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_groups.rds_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |
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
| [aws_ssm_parameter.featuredbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.github_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.jwt_issuer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.jwt_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.notificationdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.opensearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.opensearch_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.opensearch_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.redis_database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.redis_host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.redis_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.videoconfrencingdbdatabase](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.helm_values_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_inbound_rules"></a> [additional\_inbound\_rules](#input\_additional\_inbound\_rules) | n/a | <pre>list(object({<br>    name        = string<br>    description = string<br>    type        = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | Alarm action list | `list(string)` | `[]` | no |
| <a name="input_alarm_cpu_threshold_percent"></a> [alarm\_cpu\_threshold\_percent](#input\_alarm\_cpu\_threshold\_percent) | CPU threshold alarm level | `number` | `75` | no |
| <a name="input_alarm_memory_threshold_bytes"></a> [alarm\_memory\_threshold\_bytes](#input\_alarm\_memory\_threshold\_bytes) | Ram threshold alarm level | `number` | `10000000` | no |
| <a name="input_alb_url"></a> [alb\_url](#input\_alb\_url) | ALB DNS Record | `string` | n/a | yes |
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | The path for the API call , ex: /path?param=value. | `string` | `"/main/home"` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply changes immediately | `bool` | `true` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Enable encryption at rest | `bool` | `false` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars | `string` | `null` | no |
| <a name="input_authenticationdbdatabase"></a> [authenticationdbdatabase](#input\_authenticationdbdatabase) | n/a | `string` | `"auth"` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported if the engine version is 6 or higher. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Automatic failover (Not available for T1/T2 instances) | `bool` | `false` | no |
| <a name="input_canary_enabled"></a> [canary\_enabled](#input\_canary\_enabled) | To determine whether to create canary run or not | `bool` | `true` | no |
| <a name="input_cloudwatch_metric_alarms_enabled"></a> [cloudwatch\_metric\_alarms\_enabled](#input\_cloudwatch\_metric\_alarms\_enabled) | Boolean flag to enable/disable CloudWatch metrics alarms | `bool` | `false` | no |
| <a name="input_cluster_mode_enabled"></a> [cluster\_mode\_enabled](#input\_cluster\_mode\_enabled) | Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed | `bool` | `false` | no |
| <a name="input_cluster_mode_num_node_groups"></a> [cluster\_mode\_num\_node\_groups](#input\_cluster\_mode\_num\_node\_groups) | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications | `number` | `0` | no |
| <a name="input_cluster_mode_replicas_per_node_group"></a> [cluster\_mode\_replicas\_per\_node\_group](#input\_cluster\_mode\_replicas\_per\_node\_group) | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource | `number` | `0` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`* | `number` | `1` | no |
| <a name="input_create_parameter_group"></a> [create\_parameter\_group](#input\_create\_parameter\_group) | Whether new parameter group should be created. Set to false if you want to use existing parameter group | `bool` | `true` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Enter Defeault Redirect URL | `string` | `""` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Redis engine version | `string` | `"6.2"` | no |
| <a name="input_enhanced_monitoring_name"></a> [enhanced\_monitoring\_name](#input\_enhanced\_monitoring\_name) | Name for enhanced monitoring. | `string` | `"postgres"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | Redis family | `string` | `"redis6.x"` | no |
| <a name="input_featuredbdatabase"></a> [featuredbdatabase](#input\_featuredbdatabase) | ################################################################################# # Postgres DBs ################################################################################# | `string` | `"feature"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Elastic cache instance type | `string` | `"cache.t3.small"` | no |
| <a name="input_jwt_issuer"></a> [jwt\_issuer](#input\_jwt\_issuer) | jwt issuer | `string` | n/a | yes |
| <a name="input_karpenter_role"></a> [karpenter\_role](#input\_karpenter\_role) | EKS Karpenter Role | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window | `string` | `"sun:03:00-sun:04:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored) | `bool` | `false` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the resources. | `string` | n/a | yes |
| <a name="input_notificationdbdatabase"></a> [notificationdbdatabase](#input\_notificationdbdatabase) | n/a | `string` | `"notification"` | no |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN) | `list(string)` | `[]` | no |
| <a name="input_parameter"></a> [parameter](#input\_parameter) | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_rds_enable_custom_option_group"></a> [rds\_enable\_custom\_option\_group](#input\_rds\_enable\_custom\_option\_group) | Flag to enable custom option group for the RDS instance. | `bool` | `false` | no |
| <a name="input_rds_instance_allocated_storage"></a> [rds\_instance\_allocated\_storage](#input\_rds\_instance\_allocated\_storage) | The amount of allocated storage in gigabytes for the RDS instance. | `number` | `20` | no |
| <a name="input_rds_instance_allow_major_version_upgrade"></a> [rds\_instance\_allow\_major\_version\_upgrade](#input\_rds\_instance\_allow\_major\_version\_upgrade) | Flag to allow major version upgrades for the RDS instance. | `bool` | `false` | no |
| <a name="input_rds_instance_apply_immediately"></a> [rds\_instance\_apply\_immediately](#input\_rds\_instance\_apply\_immediately) | Flag to apply changes immediately or during the next maintenance window for the RDS instance. | `bool` | `true` | no |
| <a name="input_rds_instance_auto_minor_version_upgrade"></a> [rds\_instance\_auto\_minor\_version\_upgrade](#input\_rds\_instance\_auto\_minor\_version\_upgrade) | Flag to enable automatic minor version upgrades for the RDS instance. | `bool` | `true` | no |
| <a name="input_rds_instance_backup_retention_period"></a> [rds\_instance\_backup\_retention\_period](#input\_rds\_instance\_backup\_retention\_period) | The number of days to retain automated backups for the RDS instance. | `number` | `0` | no |
| <a name="input_rds_instance_backup_window"></a> [rds\_instance\_backup\_window](#input\_rds\_instance\_backup\_window) | The daily time range during which automated backups are created for the RDS instance. | `string` | `"22:00-23:59"` | no |
| <a name="input_rds_instance_ca_cert_identifier"></a> [rds\_instance\_ca\_cert\_identifier](#input\_rds\_instance\_ca\_cert\_identifier) | The identifier of the CA certificate for the RDS instance. | `string` | `"rds-ca-rsa2048-g1"` | no |
| <a name="input_rds_instance_copy_tags_to_snapshot"></a> [rds\_instance\_copy\_tags\_to\_snapshot](#input\_rds\_instance\_copy\_tags\_to\_snapshot) | Flag to copy tags to the final DB snapshot when deleting the RDS instance. | `bool` | `true` | no |
| <a name="input_rds_instance_database_name"></a> [rds\_instance\_database\_name](#input\_rds\_instance\_database\_name) | The name of the initial database on the RDS instance. | `string` | `"postgres"` | no |
| <a name="input_rds_instance_database_port"></a> [rds\_instance\_database\_port](#input\_rds\_instance\_database\_port) | The port on which the RDS instance accepts connections. | `number` | `5432` | no |
| <a name="input_rds_instance_db_options"></a> [rds\_instance\_db\_options](#input\_rds\_instance\_db\_options) | List of DB options for the RDS instance. | `list(any)` | `[]` | no |
| <a name="input_rds_instance_db_parameter"></a> [rds\_instance\_db\_parameter](#input\_rds\_instance\_db\_parameter) | List of DB parameters for the RDS instance. | `list(any)` | <pre>[<br>  {<br>    "apply_method": "immediate",<br>    "name": "rds.force_ssl",<br>    "value": "0"<br>  }<br>]</pre> | no |
| <a name="input_rds_instance_db_parameter_group"></a> [rds\_instance\_db\_parameter\_group](#input\_rds\_instance\_db\_parameter\_group) | The name of the DB parameter group to associate with the RDS instance. | `string` | `"postgres16"` | no |
| <a name="input_rds_instance_enabled"></a> [rds\_instance\_enabled](#input\_rds\_instance\_enabled) | Flag to enable or disable the RDS instance. | `bool` | `true` | no |
| <a name="input_rds_instance_engine"></a> [rds\_instance\_engine](#input\_rds\_instance\_engine) | The name of the database engine to be used for the RDS instance. | `string` | `"postgres"` | no |
| <a name="input_rds_instance_engine_version"></a> [rds\_instance\_engine\_version](#input\_rds\_instance\_engine\_version) | The version of the database engine to be used for the RDS instance. | `string` | `"16.1"` | no |
| <a name="input_rds_instance_instance_class"></a> [rds\_instance\_instance\_class](#input\_rds\_instance\_instance\_class) | The instance class for the RDS instance. | `string` | `"db.t3.small"` | no |
| <a name="input_rds_instance_maintenance_window"></a> [rds\_instance\_maintenance\_window](#input\_rds\_instance\_maintenance\_window) | The maintenance window for the RDS instance. | `string` | `"Mon:00:00-Mon:02:00"` | no |
| <a name="input_rds_instance_major_engine_version"></a> [rds\_instance\_major\_engine\_version](#input\_rds\_instance\_major\_engine\_version) | The major version of the database engine to be used for the RDS instance. | `string` | `"16"` | no |
| <a name="input_rds_instance_multi_az"></a> [rds\_instance\_multi\_az](#input\_rds\_instance\_multi\_az) | Flag to enable multi-AZ deployment for the RDS instance. | `bool` | `false` | no |
| <a name="input_rds_instance_name"></a> [rds\_instance\_name](#input\_rds\_instance\_name) | The name of the RDS instance. | `string` | `"postgres"` | no |
| <a name="input_rds_instance_publicly_accessible"></a> [rds\_instance\_publicly\_accessible](#input\_rds\_instance\_publicly\_accessible) | Flag to make the RDS instance publicly accessible. | `bool` | `false` | no |
| <a name="input_rds_instance_skip_final_snapshot"></a> [rds\_instance\_skip\_final\_snapshot](#input\_rds\_instance\_skip\_final\_snapshot) | Flag to skip the final DB snapshot when deleting the RDS instance. | `bool` | `true` | no |
| <a name="input_rds_instance_snapshot_identifier"></a> [rds\_instance\_snapshot\_identifier](#input\_rds\_instance\_snapshot\_identifier) | The identifier for the RDS instance snapshot to be used for restoring the instance. | `string` | `null` | no |
| <a name="input_rds_instance_storage_encrypted"></a> [rds\_instance\_storage\_encrypted](#input\_rds\_instance\_storage\_encrypted) | Flag to enable storage encryption for the RDS instance. | `bool` | `false` | no |
| <a name="input_rds_instance_storage_type"></a> [rds\_instance\_storage\_type](#input\_rds\_instance\_storage\_type) | The storage type for the RDS instance. | `string` | `"gp2"` | no |
| <a name="input_redis_database"></a> [redis\_database](#input\_redis\_database) | Redis Database | `string` | `"0"` | no |
| <a name="input_redis_port"></a> [redis\_port](#input\_redis\_port) | Redis Port | `number` | `6379` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | Runtime version of the canary. Details: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Library_nodejs_puppeteer.html | `string` | `"syn-nodejs-puppeteer-7.0"` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. | `number` | `0` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. | `string` | `"06:30-07:30"` | no |
| <a name="input_take_screenshot"></a> [take\_screenshot](#input\_take\_screenshot) | If screenshot should be taken | `bool` | `false` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | tenant name | `string` | n/a | yes |
| <a name="input_tenant_client_id"></a> [tenant\_client\_id](#input\_tenant\_client\_id) | tenant Client ID | `string` | n/a | yes |
| <a name="input_tenant_client_secret"></a> [tenant\_client\_secret](#input\_tenant\_client\_secret) | tenant Client Secret | `string` | n/a | yes |
| <a name="input_tenant_email"></a> [tenant\_email](#input\_tenant\_email) | tenant Email | `string` | n/a | yes |
| <a name="input_tenant_host_domain"></a> [tenant\_host\_domain](#input\_tenant\_host\_domain) | tenant Host | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenat unique ID | `string` | n/a | yes |
| <a name="input_tenant_name"></a> [tenant\_name](#input\_tenant\_name) | Tenant Name | `string` | n/a | yes |
| <a name="input_tenant_secret"></a> [tenant\_secret](#input\_tenant\_secret) | tenant secret | `string` | n/a | yes |
| <a name="input_tenant_tier"></a> [tenant\_tier](#input\_tenant\_tier) | Tenant Tier | `string` | n/a | yes |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | A list of DB timeouts to apply to the running code while creating, updating, or deleting the DB instance. | <pre>object({<br>    create = string<br>    update = string<br>    delete = string<br>  })</pre> | <pre>{<br>  "create": "40m",<br>  "delete": "60m",<br>  "update": "80m"<br>}</pre> | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.<br>If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis. | `bool` | `false` | no |
| <a name="input_user_callback_secret"></a> [user\_callback\_secret](#input\_user\_callback\_secret) | Secret for user tenant service | `string` | n/a | yes |
| <a name="input_videoconfrencingdbdatabase"></a> [videoconfrencingdbdatabase](#input\_videoconfrencingdbdatabase) | n/a | `string` | `"video"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->