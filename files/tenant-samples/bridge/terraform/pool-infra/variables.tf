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

variable "tenant_tier" {
  type = string
  description = "Tenant Tier"
}

# ##################################################################################
# ## database
# ##################################################################################
# variable "timeouts" {
#   type = object({
#     create = string
#     update = string
#     delete = string
#   })
#   description = "A list of DB timeouts to apply to the running code while creating, updating, or deleting the DB instance."
#   default = {
#     create = "40m"
#     update = "80m"
#     delete = "60m"
#   }
# }

# variable "aurora_cluster_enabled" {
#   type        = bool
#   description = "Enable creation of an Aurora Cluster"
#   default     = true
# }

# variable "deletion_protection" {
#   description = "Protect the instance from being deleted"
#   type        = bool
#   default     = false
# }

# variable "aurora_db_name" {
#   type        = string
#   default     = "auroradb"
#   description = "Database name."
# }

# variable "aurora_db_port" {
#   type        = number
#   description = "Port for the Aurora DB instance to use."
#   default     = 5432
# }

# variable "aurora_cluster_family" {
#   type        = string
#   default     = "aurora-postgresql15"
#   description = "The family of the DB cluster parameter group"
# }

# variable "aurora_engine" {
#   type        = string
#   default     = "aurora-postgresql"
#   description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
# }

# variable "aurora_engine_mode" {
#   type        = string
#   default     = "provisioned"
#   description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
# }

# variable "aurora_storage_type" {
#   type        = string
#   description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD) or aurora-iopt1"
#   default     = "aurora-iopt1"
# }

# variable "aurora_engine_version" {
#   description = "The version of the database engine tocl use. See `aws rds describe-db-engine-versions` "
#   type        = string
#   default     = "15.4"
# }

# variable "aurora_allow_major_version_upgrade" {
#   type        = bool
#   default     = false
#   description = "Enable to allow major engine version upgrades when changing engine versions. Defaults to false."
# }

# variable "aurora_auto_minor_version_upgrade" {
#   type        = bool
#   default     = true
#   description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
# }

# variable "aurora_instance_type" {
#   type        = string
#   default     = "db.t3.medium"
#   description = "Instance type to use"
# }

# variable "aurora_cluster_size" {
#   type        = number
#   default     = 1
#   description = "Number of DB instances to create in the cluster"
# }

# variable "aurora_serverlessv2_scaling_configuration" {
#   description = "serverlessv2 scaling properties"
#   type = object({
#     min_capacity = number
#     max_capacity = number
#   })
#   default = null
# }

# variable "performance_insights_enabled" {
#   type        = bool
#   default     = true
#   description = "Whether to enable Performance Insights"
# }

# variable "performance_insights_retention_period" {
#   description = "Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
#   type        = number
#   default     = 7
# }

# variable "iam_database_authentication_enabled" {
#   type        = bool
#   description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
#   default     = false
# }

# variable "aurora_iops" {
#   type        = number
#   description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. This setting is required to create a Multi-AZ DB cluster. Check TF docs for values based on db engine"
#   default     = null
# }

# variable "additional_inbound_rules" {
#   type = list(object({
#     description       = string
#     from_port         = number
#     to_port           = number
#     protocol          = string
#     cidr_blocks       = list(string)
#     security_group_id = optional(list(string))
#     ipv6_cidr_blocks  = optional(list(string))

#   }))
#   default = []
# }

# ##################################################################################
# ## Postgres DBs
# ##################################################################################
# variable "featuredbdatabase" {
#   type    = string
#   default = "feature"
# }

# variable "authenticationdbdatabase" {
#   type    = string
#   default = "auth"
# }

# variable "notificationdbdatabase" {
#   type    = string
#   default = "notification"
# }

# variable "videoconfrencingdbdatabase" {
#   type    = string
#   default = "video"
# }

# ###################################################################################
# ## Redis Elasticache
# ###################################################################################
# variable "maintenance_window" {
#   type        = string
#   default     = "sun:03:00-sun:04:00"
#   description = "Maintenance window"
# }

# variable "cluster_size" {
#   type        = number
#   default     = 1
#   description = "Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`*"
# }

# variable "instance_type" {
#   type        = string
#   default     = "cache.t3.small"
#   description = "Elastic cache instance type"
# }

# variable "family" {
#   type        = string
#   default     = "redis6.x"
#   description = "Redis family"
# }

# variable "parameter" {
#   type = list(object({
#     name  = string
#     value = string
#   }))
#   default     = []
#   description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
# }

# variable "engine_version" {
#   type        = string
#   default     = "6.2"
#   description = "Redis engine version"
# }

# variable "at_rest_encryption_enabled" {
#   type        = bool
#   default     = false
#   description = "Enable encryption at rest"
# }

# variable "transit_encryption_enabled" {
#   type        = bool
#   default     = false
#   description = <<-EOT
#     Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.
#     If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis.
#     EOT
# }

# variable "apply_immediately" {
#   type        = bool
#   default     = true
#   description = "Apply changes immediately"
# }

# variable "cluster_mode_enabled" {
#   type        = bool
#   description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
#   default     = false
# }

# variable "cluster_mode_replicas_per_node_group" {
#   type        = number
#   description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
#   default     = 0
# }

# variable "cluster_mode_num_node_groups" {
#   type        = number
#   description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
#   default     = 0
# }

# variable "snapshot_window" {
#   type        = string
#   description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
#   default     = "06:30-07:30"
# }

# variable "snapshot_retention_limit" {
#   type        = number
#   description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
#   default     = 0
# }

# variable "auth_token" {
#   type        = string
#   description = "Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars"
#   default     = null
# }

# variable "create_parameter_group" {
#   type        = bool
#   default     = true
#   description = "Whether new parameter group should be created. Set to false if you want to use existing parameter group"
# }

# variable "auto_minor_version_upgrade" {
#   type        = bool
#   default     = true
#   description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported if the engine version is 6 or higher."
# }

# variable "automatic_failover_enabled" {
#   type        = bool
#   default     = false
#   description = "Automatic failover (Not available for T1/T2 instances)"
# }

# variable "multi_az_enabled" {
#   type        = bool
#   default     = false
#   description = "Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored)"
# }

# variable "redis_port" {
#   description = "Redis Port"
#   type        = number
#   default     = 6379
# }

# variable "redis_database" {
#   description = "Redis Database"
#   type        = string
#   default     = "0"
# }

# variable "cloudwatch_metric_alarms_enabled" {
#   type        = bool
#   description = "Boolean flag to enable/disable CloudWatch metrics alarms"
#   default     = false
# }

# variable "alarm_cpu_threshold_percent" {
#   type        = number
#   default     = 75
#   description = "CPU threshold alarm level"
# }

# variable "alarm_memory_threshold_bytes" {
#   # 10MB
#   type        = number
#   default     = 10000000
#   description = "Ram threshold alarm level"
# }

# variable "alarm_actions" {
#   type        = list(string)
#   description = "Alarm action list"
#   default     = []
# }

# variable "ok_actions" {
#   type        = list(string)
#   description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN)"
#   default     = []
# }

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