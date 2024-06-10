################################################################
## Default
################################################################
variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

#################################################################
## Networking
#################################################################

variable "availability_zones" {
  description = "List of availability zones to deploy resources in."
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "vpc_ipv4_primary_cidr_block" {
  description = "CIDR block for the VPC to use."
  type        = string
  default     = "10.0.0.0/16"
}

variable "is_custom_subnet_enabled" {
  type        = bool
  default     = false
  description = "Enable to create subnets with custom cidr range"
}

variable "private_subnet_count" {
  type        = number
  default     = 2
  description = "Number of private subnets required"
}

variable "public_subnet_count" {
  type        = number
  default     = 2
  description = "Number of public subnets required"
}

variable "custom_private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "list of CIDR block for private subnets"
}

variable "custom_public_subnet_ids" {
  type        = list(string)
  default     = []
  description = "list of CIDR block for public subnets"
}

variable "custom_create_aws_network_acl" {
  type        = bool
  description = "This indicates whether to create aws network acl or not"
  default     = true
}

variable "custom_nat_gateway_enabled" {
  description = "Enable the NAT Gateway between public and private subnets"
  type        = bool
  default     = true
}

variable "client_vpn_enabled" {
  type        = bool
  description = "Enable client VPN endpoint"
  default     = false
}

variable "client_vpn_authorization_rules" {
  type        = list(map(any))
  default     = []
  description = "List of objects describing the authorization rules for the client vpn"
}

################################################################################
## vpc endpoint
################################################################################
variable "vpc_endpoints_enabled" {
  type        = bool
  description = "Enable VPC endpoints."
  default     = false
}

variable "vpc_endpoint_type" {
  type        = string
  description = "The VPC endpoint type, Gateway, GatewayLoadBalancer, or Interface."
  default     = "Interface"
}

variable "enable_s3_endpoint" {
  type        = bool
  description = "Enable S3 endpoints"
  default     = false
}

variable "enable_kms_endpoint" {
  type        = bool
  description = "Enable KMS endpoints"
  default     = false
}

variable "enable_cloudwatch_endpoint" {
  type        = bool
  description = "Enable CloudWatch endpoints"
  default     = false
}

variable "enable_elb_endpoint" {
  type        = bool
  description = "Enable ELB endpoints"
  default     = false
}

variable "enable_dynamodb_endpoint" {
  type        = bool
  description = "Enable DynamoDB endpoints"
  default     = false
}

variable "enable_ec2_endpoint" {
  type        = bool
  description = "Enable EC2 endpoints"
  default     = false
}

variable "enable_sns_endpoint" {
  type        = bool
  description = "Enable SNS endpoints"
  default     = false
}

variable "enable_ecs_endpoint" {
  type        = bool
  description = "Enable ECS endpoints"
  default     = false
}

variable "enable_sqs_endpoint" {
  type        = bool
  description = "Enable SQS endpoints"
  default     = false
}

variable "enable_rds_endpoint" {
  type        = bool
  description = "Enable RDS endpoints"
  default     = false
}