################################################################################
## shared
################################################################################
variable "region" {
  type        = string
  default     = "us-east-1"
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
################################################################################
## db
################################################################################
variable "aurora_cluster_enabled" {
  type        = bool
  description = "Enable creation of an Aurora Cluster"
  default     = true
}

variable "deletion_protection" {
  description = "Protect the instance from being deleted"
  type        = bool
  default     = false
}

variable "aurora_db_admin_username" {
  type        = string
  description = "Name of the default DB admin user role"
  default     = ""
}

variable "aurora_db_name" {
  type        = string
  default     = "auroradb"
  description = "Database name."
}

variable "aurora_db_port" {
  type        = number
  description = "Port for the Aurora DB instance to use."
  default     = 5432
}

variable "aurora_cluster_family" {
  type        = string
  default     = "aurora-postgresql15"
  description = "The family of the DB cluster parameter group"
}

variable "aurora_engine" {
  type        = string
  default     = "aurora-postgresql"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "aurora_engine_mode" {
  type        = string
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "aurora_engine_version" {
  description = "The version of the database engine tocl use. See `aws rds describe-db-engine-versions` "
  type        = string
  default     = "14.7" // "aurora-postgresql14.5"
}

variable "aurora_allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Enable to allow major engine version upgrades when changing engine versions. Defaults to false."
}

variable "aurora_auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
}

variable "aurora_cluster_size" {
  type        = number
  default     = 1
  description = "Number of DB instances to create in the cluster"
}

variable "aurora_instance_type" {
  type        = string
  default     = "db.t3.medium"
  description = "Instance type to use"
}

variable "aurora_serverlessv2_scaling_configuration" {
  description = "serverlessv2 scaling properties"
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable Performance Insights"
}

variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)"
  type        = number
  default     = null
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default     = false
}

variable "aurora_storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD) or aurora-iopt1"
  default     = null
}

variable "aurora_iops" {
  type        = number
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. This setting is required to create a Multi-AZ DB cluster. Check TF docs for values based on db engine"
  default     = null
}

##################################################################################
## Security Group
##################################################################################
variable "additional_inbound_rules" {
  type = list(object({
    description       = string
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = list(string)
    security_group_id = optional(list(string))
    ipv6_cidr_blocks  = optional(list(string))

  }))
  default = []
}
