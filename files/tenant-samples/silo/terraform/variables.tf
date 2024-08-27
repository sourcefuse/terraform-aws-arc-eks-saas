################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "tenant" {
  type        = string
  description = "tenant name"
}

variable "tenant_id" {
  type        = string
  description = "Tenat unique ID"
}

##################################################################################
## database
##################################################################################
variable "timeouts" {
  type = object({
    create = string
    update = string
    delete = string
  })
  description = "A list of DB timeouts to apply to the running code while creating, updating, or deleting the DB instance."
  default = {
    create = "40m"
    update = "80m"
    delete = "60m"
  }
}

#######################################################################
## RDS
#######################################################################
variable "rds_instance_enabled" {
  description = "Flag to enable or disable the RDS instance."
  type        = bool
  default     = true
}

variable "rds_instance_name" {
  description = "The name of the RDS instance."
  type        = string
  default     = "postgres"
}

variable "enhanced_monitoring_name" {
  description = "Name for enhanced monitoring."
  type        = string
  default     = "postgres"
}

variable "rds_instance_database_name" {
  description = "The name of the initial database on the RDS instance."
  type        = string
  default     = "postgres"
}

variable "rds_instance_database_port" {
  description = "The port on which the RDS instance accepts connections."
  type        = number
  default     = 5432
}

variable "rds_instance_engine" {
  description = "The name of the database engine to be used for the RDS instance."
  type        = string
  default     = "postgres"
}

variable "rds_instance_engine_version" {
  description = "The version of the database engine to be used for the RDS instance."
  type        = string
  default     = "16.1"
}

variable "rds_instance_major_engine_version" {
  description = "The major version of the database engine to be used for the RDS instance."
  type        = string
  default     = "16"
}

variable "rds_instance_db_parameter_group" {
  description = "The name of the DB parameter group to associate with the RDS instance."
  type        = string
  default     = "postgres16"
}

variable "rds_instance_db_parameter" {
  description = "List of DB parameters for the RDS instance."
  type        = list(any)
  default = [
    {
      apply_method = "immediate"
      name         = "rds.force_ssl"
      value        = "0"
    }
  ]
}

variable "rds_instance_db_options" {
  description = "List of DB options for the RDS instance."
  type        = list(any)
  default     = []
}

variable "rds_enable_custom_option_group" {
  description = "Flag to enable custom option group for the RDS instance."
  type        = bool
  default     = false
}

variable "rds_instance_ca_cert_identifier" {
  description = "The identifier of the CA certificate for the RDS instance."
  type        = string
  default     = "rds-ca-rsa2048-g1"
}

variable "rds_instance_publicly_accessible" {
  description = "Flag to make the RDS instance publicly accessible."
  type        = bool
  default     = false
}

variable "rds_instance_multi_az" {
  description = "Flag to enable multi-AZ deployment for the RDS instance."
  type        = bool
  default     = false
}

variable "rds_instance_storage_type" {
  description = "The storage type for the RDS instance."
  type        = string
  default     = "gp2"
}

variable "rds_instance_instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
  default     = "db.t3.small"
}

variable "rds_instance_allocated_storage" {
  description = "The amount of allocated storage in gigabytes for the RDS instance."
  type        = number
  default     = 20
}

variable "rds_instance_storage_encrypted" {
  description = "Flag to enable storage encryption for the RDS instance."
  type        = bool
  default     = false
}

variable "rds_instance_snapshot_identifier" {
  description = "The identifier for the RDS instance snapshot to be used for restoring the instance."
  type        = string
  default     = null
}

variable "rds_instance_auto_minor_version_upgrade" {
  description = "Flag to enable automatic minor version upgrades for the RDS instance."
  type        = bool
  default     = true
}

variable "rds_instance_allow_major_version_upgrade" {
  description = "Flag to allow major version upgrades for the RDS instance."
  type        = bool
  default     = false
}

variable "rds_instance_apply_immediately" {
  description = "Flag to apply changes immediately or during the next maintenance window for the RDS instance."
  type        = bool
  default     = true
}

variable "rds_instance_maintenance_window" {
  description = "The maintenance window for the RDS instance."
  type        = string
  default     = "Mon:00:00-Mon:02:00"
}

variable "rds_instance_skip_final_snapshot" {
  description = "Flag to skip the final DB snapshot when deleting the RDS instance."
  type        = bool
  default     = true
}

variable "rds_instance_copy_tags_to_snapshot" {
  description = "Flag to copy tags to the final DB snapshot when deleting the RDS instance."
  type        = bool
  default     = true
}

variable "rds_instance_backup_retention_period" {
  description = "The number of days to retain automated backups for the RDS instance."
  type        = number
  default     = 0
}

variable "rds_instance_backup_window" {
  description = "The daily time range during which automated backups are created for the RDS instance."
  type        = string
  default     = "22:00-23:59"
}


variable "additional_inbound_rules" {
  type = list(object({
    name        = string
    description = string
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

##################################################################################
## Postgres DBs
##################################################################################
variable "featuredbdatabase" {
  type    = string
  default = "feature"
}

variable "authenticationdbdatabase" {
  type    = string
  default = "auth"
}

variable "notificationdbdatabase" {
  type    = string
  default = "notification"
}

variable "videoconfrencingdbdatabase" {
  type    = string
  default = "video"
}
###################################################################################
## Redis Elasticache
###################################################################################
variable "maintenance_window" {
  type        = string
  default     = "sun:03:00-sun:04:00"
  description = "Maintenance window"
}

variable "cluster_size" {
  type        = number
  default     = 1
  description = "Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`*"
}

variable "instance_type" {
  type        = string
  default     = "cache.t3.small"
  description = "Elastic cache instance type"
}

variable "family" {
  type        = string
  default     = "redis6.x"
  description = "Redis family"
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}

variable "engine_version" {
  type        = string
  default     = "6.2"
  description = "Redis engine version"
}

variable "at_rest_encryption_enabled" {
  type        = bool
  default     = false
  description = "Enable encryption at rest"
}

variable "transit_encryption_enabled" {
  type        = bool
  default     = false
  description = <<-EOT
    Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.
    If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis.
    EOT
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Apply changes immediately"
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = false
}

variable "cluster_mode_replicas_per_node_group" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  default     = 0
}

variable "cluster_mode_num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  default     = 0
}

variable "snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "06:30-07:30"
}

variable "snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 0
}

variable "auth_token" {
  type        = string
  description = "Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars"
  default     = null
}

variable "create_parameter_group" {
  type        = bool
  default     = true
  description = "Whether new parameter group should be created. Set to false if you want to use existing parameter group"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported if the engine version is 6 or higher."
}

variable "automatic_failover_enabled" {
  type        = bool
  default     = false
  description = "Automatic failover (Not available for T1/T2 instances)"
}

variable "multi_az_enabled" {
  type        = bool
  default     = false
  description = "Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored)"
}

variable "redis_port" {
  description = "Redis Port"
  type        = number
  default     = 6379
}

variable "redis_database" {
  description = "Redis Database"
  type        = string
  default     = "0"
}

variable "cloudwatch_metric_alarms_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable CloudWatch metrics alarms"
  default     = false
}

variable "alarm_cpu_threshold_percent" {
  type        = number
  default     = 75
  description = "CPU threshold alarm level"
}

variable "alarm_memory_threshold_bytes" {
  # 10MB
  type        = number
  default     = 10000000
  description = "Ram threshold alarm level"
}

variable "alarm_actions" {
  type        = list(string)
  description = "Alarm action list"
  default     = []
}

variable "ok_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN)"
  default     = []
}

#################################################################################
## Cognito
#################################################################################
variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username. Conflicts with `username_attributes`"
  type        = list(string)
  default     = ["email", "phone_number", "preferred_username"]
}

variable "auto_verified_attributes" {
  description = "The attributes to be auto-verified. Possible values: email, phone_number"
  type        = list(string)
  default     = ["email"]
}

variable "sms_authentication_message" {
  description = "A string representing the SMS authentication message"
  type        = string
  default     = "Your username is {username} and temporary password is {####}."
}

variable "sms_verification_message" {
  description = "A string representing the SMS verification message"
  type        = string
  default     = "This is the verification message {####}."
}

variable "cognito_deletion_protection" {
  description = "When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature. Valid values are `ACTIVE` and `INACTIVE`."
  type        = string
  default     = "INACTIVE"
}

variable "mfa_configuration" {
  description = "Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL)"
  type        = string
  default     = "OFF"
}

variable "software_token_mfa_configuration" {
  description = "Configuration block for software token MFA (multifactor-auth). mfa_configuration must also be enabled for this to work"
  type        = map(any)
  default     = {}
}

variable "software_token_mfa_configuration_enabled" {
  description = "If true, and if mfa_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled"
  type        = bool
  default     = true
}

variable "admin_create_user_config" {
  description = "The configuration for AdminCreateUser requests"
  type        = map(any)
  default = {
    email_message = "Dear {username}, your temporary password is {####}."
    email_subject = "Here, your temporary password"
    sms_message   = "Your username is {username} and temporary password is {####}."
  }
}

variable "admin_create_user_config_allow_admin_create_user_only" {
  description = "Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app"
  type        = bool
  default     = false
}

# device_configuration
variable "device_configuration" {
  description = "The configuration for the user pool's device tracking"
  type        = map(any)
  default = {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }
}

# email_configuration
variable "email_configuration" {
  description = "The Email Configuration"
  type        = map(any)
  default = {
    email_sending_account  = "COGNITO_DEFAULT"
    reply_to_email_address = ""
    source_arn             = ""
  }
}


# password_policy
variable "password_policy" {
  description = "A container for information about the user pool password policy"
  type = object({
    minimum_length                   = number,
    require_lowercase                = bool,
    require_numbers                  = bool,
    require_symbols                  = bool,
    require_uppercase                = bool,
    temporary_password_validity_days = number
  })
  default = {
    minimum_length                   = 10
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
}

variable "user_pool_add_ons_advanced_security_mode" {
  description = "The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED`"
  type        = string
  default     = "OFF"
}

# aws_cognito_user_pool

variable "user_groups" {
  description = "A container with the user_groups definitions"
  type        = list(any)
  default     = []
}

variable "clients" {
  description = "A container with the clients definitions"
  type        = any
  default     = []
}

variable "client_prevent_user_existence_errors" {
  description = "Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool."
  type        = string
  default     = "ENABLED"
}

variable "resource_servers" {
  description = "A container with the user_groups definitions"
  type        = list(any)
  default     = []
}

variable "identity_providers" {
  description = "Cognito Pool Identity Providers"
  type        = list(any)
  default     = []
  sensitive   = true
}

variable "recovery_mechanisms" {
  description = "The list of Account Recovery Options"
  type        = list(any)
  default     = []
}

variable "domain_name" {
  description = "Enter Defeault Redirect URL"
  type        = string
  default     = ""
}

#################################################################################
## Helm
#################################################################################
variable "tenant_email" {
  type        = string
  description = "tenant Email"
}

variable "user_name" {
  type        = string
  description = "cognito user"
}

variable "tenant_name" {
  type        = string
  description = "Tenant Name"
}

variable "tenant_secret" {
  type        = string
  description = "tenant secret"
}

variable "user_callback_secret" {
  type        = string
  description = "Secret for user tenant service"
}

variable "tenant_client_id" {
  type        = string
  description = "tenant Client ID"
}

variable "tenant_client_secret" {
  type        = string
  description = "tenant Client Secret"
}

variable "karpenter_role" {
  type        = string
  description = "EKS Karpenter Role"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "tenant_host_domain" {
  type        = string
  description = "tenant Host"
}

variable "jwt_issuer" {
  type        = string
  description = "jwt issuer"
}

variable "alb_url" {
  type        = string
  description = "ALB DNS Record"
}

variable "karpenter_instance_category" {
  type        = string
  description = "karpenter instance category"
}

variable "tenant_tier" {
  type        = string
  description = "Tenant Tier Category"
}
#################################################################
## Canary Variables
#################################################################
variable "runtime_version" {
  description = "Runtime version of the canary. Details: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Library_nodejs_puppeteer.html"
  type        = string
  default     = "syn-nodejs-puppeteer-7.0"
}

variable "take_screenshot" {
  description = "If screenshot should be taken"
  type        = bool
  default     = false
}

variable "api_path" {
  description = "The path for the API call , ex: /path?param=value."
  type        = string
  default     = "/main/home"
}

variable "canary_enabled" {
  description = "To determine whether to create canary run or not"
  type        = bool
  default     = true
}