variable "security_group_description" {
  type        = string
  description = "Description of the security groups"
  default     = "my-security-group"
}

variable "security_group_name" {
  type        = string
  description = "Prefix for the name of the security groups."
  default     = "my-security-group"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to create the security groups in."
}

variable "ingress_rules" {
  type = map(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string))
    security_group_id = optional(list(string))
    ipv6_cidr_blocks  = optional(list(string))
    self              = optional(bool)
  }))
  description = "Ingress rules for the security groups."
  default     = {}
}

variable "egress_rules" {
  type = map(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = string
    cidr_blocks       = optional(list(string))
    security_group_id = optional(list(string))
    ipv6_cidr_blocks  = optional(list(string))
  }))
  description = "Egress rules for the security groups."
  default     = {}
}


variable "tags" {
  type        = map(string)
  description = "Tags to assign the security groups."
}