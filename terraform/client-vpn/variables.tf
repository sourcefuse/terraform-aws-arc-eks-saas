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

################################################################################
## certs
################################################################################
variable "secret_path_format" {
  description = "The path format to use when writing secrets to the certificate backend."
  type        = string
  default     = "/%s.%s"

  validation {
    condition     = can(substr(var.secret_path_format, 0, 1) == "/")
    error_message = "The secret path format must contain a leading slash."
  }
}

variable "common_name" {
  type        = string
  description = " Domain Name  supplied as commn name."
}
################################################################################
## VPN configuration
################################################################################
variable "enable_client_vpn" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources."
  default     = true
}

variable "client_vpn_name" {
  type        = string
  description = "The name of the client vpn"
  default     = "saas-vpn"
}

variable "vpc_name_override" {
  type        = string
  description = "The name of the target network VPC."
  default     = null
}

variable "private_subnet_names_override" {
  type        = list(string)
  description = "The name of the subnets to associate to the VPN."
  default     = []
}


variable "client_vpn_log_options" {
  description = "Whether logging is enabled and where to send the logs output."
  type = object({
    enabled               = bool                   // Indicates whether connection logging is enabled
    cloudwatch_log_stream = optional(string, null) // The name of the vpn client cloudwatch log stream
    cloudwatch_log_group  = optional(string, null) // The name of the vpn client cloudwatch log group
  })
  default = {
    enabled = false
  }
}

variable "authentication_options_type" {
  type        = string
  description = <<-EOT
    The type of client authentication to be used.
    Specify certificate-authentication to use certificate-based authentication, directory-service-authentication to use Active Directory authentication,
    or federated-authentication to use Federated Authentication via SAML 2.0.
  EOT
  default     = "certificate-authentication"
}

variable "client_vpn_ingress_rules" {
  type = list(object({
    description        = optional(string, "")
    from_port          = number
    to_port            = number
    protocol           = any
    cidr_blocks        = optional(list(string), [])
    security_group_ids = optional(list(string), [])
    ipv6_cidr_blocks   = optional(list(string), [])
  }))
  description = "Ingress rules for the security groups."
  default = [
    {
      description = "VPN ingress to 443"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
    }
  ]
}