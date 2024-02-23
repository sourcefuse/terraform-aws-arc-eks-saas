variable "host" {
  type        = string
  description = "Database host"
  default     = ""
}

variable "database" {
  type        = string
  description = "Name of the database"
  default     = "postgres"
}

variable "port" {
  type        = number
  description = "Database port"
  default     = 5432
}

variable "password" {
  type        = string
  description = "Database password"
  default     = ""
}

variable "username" {
  type        = string
  description = "User name of the database"
  default     = "is_root"
}

variable "superuser" {
  type        = string
  description = "Defines whether the role is a superuser, and therefore can override all access restrictions within the database"
  default     = false
}

variable "sslmode" {
  type        = string
  description = "sslmode of the database"
  default     = "require"
}

variable "connect_timeout" {
  type        = number
  description = "connection timeout of the database"
  default     = 15
}

variable "postgresql_database" {
  type = map(object({
    db_name = string
    //db_owner          = string
    template          = optional(string, null)
    lc_collate        = optional(string, null)
    connection_limit  = optional(string, null)
    allow_connections = optional(string, null)
  }))
  description = "configuration block for postgresql database"
  default     = {}
}

variable "postgresql_default_privileges" {
  type = map(object({
    role        = string
    database    = string
    schema      = string
    owner       = string
    object_type = string
    privileges  = list(string)
  }))
  description = "configuration block for postgresql default privileges"
  default     = {}
}

variable "postgresql_schema" {
  type = map(object({
    schema_name   = string
    schema_owner  = optional(string, null)
    database      = optional(string, null)
    if_not_exists = optional(string, null)
    drop_cascade  = optional(string, null)

    policy = optional(list(object({
      usage = optional(string, null)
      role  = optional(string, null)
    })), [])
  }))
  description = "configuration block for postgresql schema"
  default     = {}
}

variable "pg_users" {
  type = list(object({
    name  = string
    login = bool
  }))
  default = []
}

variable "parameter_name_prefix" {
  description = "Prefix for the SSM parameter name"
  type        = string
  default     = ""
}