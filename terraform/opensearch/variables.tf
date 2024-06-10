################################################################################
## shared
################################################################################
variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. arc"
}

################################################################################
## opensearch
################################################################################
variable "os_additional_iam_role_arns" {
  description = "List of additional IAM role ARNs to permit access to the Elasticsearch domain"
  type        = list(string)
  default     = ["*"]
}

variable "os_iam_actions" {
  description = "List of actions to allow for the IAM roles, e.g. es:ESHttpGet, es:ESHttpPut, es:ESHttpPost"
  type        = list(string)
  default     = ["es:*"]
}

variable "create_iam_service_linked_role" {
  type        = bool
  default     = true
  description = "Whether to create `AWSServiceRoleForAmazonElasticsearchService` service-linked role. Set it to `false` if you already have an ElasticSearch cluster created in the AWS account and AWSServiceRoleForAmazonElasticsearchService already exists. See https://github.com/terraform-providers/terraform-provider-aws/issues/5218 for more info"
}

variable "elasticsearch_version" {
  type        = string
  description = "Version of ElasticSearch or OpenSearch to deploy (_e.g._ OpenSearch_2.3, OpenSearch_1.3, OpenSearch_1.2, OpenSearch_1.1, OpenSearch_1.0, 7.4, 7.1, etc."
  default     = "OpenSearch_2.11"
}

variable "instance_count" {
  type        = number
  description = "Number of data nodes in the cluster."
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "ElasticSearch or OpenSearch instance type for data nodes in the cluster"
  default     = "t3.medium.elasticsearch"
}

variable "ebs_volume_size" {
  type        = number
  description = "EBS volumes for data storage in GB"
  default     = 10
}

variable "advanced_security_options_enabled" {
  type        = bool
  description = "AWS Elasticsearch Kibana enchanced security plugin enabling (forces new resource)"
  default     = true
}

variable "advanced_options" {
  type        = map(any)
  description = "Key-value string pairs to specify advanced configuration options"
  default = {
    "rest.action.multi.allow_explicit_index" = "true"
    override_main_response_version           = false
  }
}

variable "advanced_security_options_internal_user_database_enabled" {
  type        = bool
  description = "Whether to enable or not internal Kibana user database for ELK OpenDistro security plugin"
  default     = true
}

variable "node_to_node_encryption_enabled" {
  type        = bool
  description = "Whether to enable node-to-node encryption"
  default     = true
}

variable "zone_awareness_enabled" {
  type        = bool
  description = "Enable zone awareness for Elasticsearch cluster"
  default     = true
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  description = "Whether to enable encryption at rest"
  default     = true
}

variable "kibana_subdomain_name" {
  type        = string
  description = "The name of the subdomain for Kibana in the DNS zone (_e.g._ kibana, ui, ui-es, search-ui, kibana.elasticsearch)"
  default     = ""
}

variable "custom_endpoint_enabled" {
  type        = bool
  description = "Whether to enable custom endpoint for the Elasticsearch domain."
  default     = false
}

variable "custom_endpoint" {
  type        = string
  description = "Fully qualified domain for custom endpoint."
  default     = ""
}

variable "custom_endpoint_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for custom endpoint."
  default     = ""
}

variable "admin_username" {
  type        = string
  description = "Admin username when fine grained access control"
  default     = "os_admin"
}

variable "generate_random_password" {
  type        = bool
  description = <<-EOF
    Generate a random password for the OpenSearch Administrator.
    If this value is `true` and `var.custom_opensearch_password` is defined, `var.custom_opensearch_password` will be ignored.
  EOF
  default     = true
}

variable "custom_opensearch_password" {
  type        = string
  description = "Custom Administrator password to be assigned to `var.admin_username`. If undefined, it will be a randomly generated password. Does not work if `var.generate_random_password` is `true`."
  sensitive   = true
  default     = ""
}
################################################################################
## cognito
################################################################################
variable "cognito_authentication_enabled" {
  type        = bool
  description = "Whether to enable Amazon Cognito authentication with Kibana"
  default     = false
}

variable "cognito_user_pool_id" {
  type        = string
  description = "The ID of the Cognito User Pool to use"
  default     = ""
}

variable "cognito_identity_pool_id" {
  type        = string
  description = "The ID of the Cognito Identity Pool to use"
  default     = ""
}

variable "cognito_iam_role_arn" {
  type        = string
  description = "ARN of the IAM role that has the AmazonESCognitoAccess policy attached"
  default     = ""
}
################################################################################
## security group
################################################################################
variable "additional_sg_rules" {
  description = "Additional inbound rules to assign to the OpenSearch Cluster"
  type = list(object({
    name              = string // unique name for the SG rules
    from_port         = number
    to_port           = number
    type              = string // ingress or egress
    description       = optional(string, "Managed by Terraform")
    protocol          = optional(string, "TCP")
    cidr_blocks       = list(string)
    security_group_id = optional(list(string))
    ipv6_cidr_blocks  = optional(list(string))
  }))
  default = []
}