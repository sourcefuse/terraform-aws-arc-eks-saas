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
## WAF
################################################################################
variable "enabled" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources"
}

variable "default_action" {
  type        = string
  default     = "allow"
  description = "Specifies that AWS WAF should allow requests by default. Possible values: `allow`, `block`."
  nullable    = false
  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Allowed values: `allow`, `block`."
  }
}


variable "ip_set_reference_statement_rules" {
  type = list(object({
    name     = string
    priority = number
    action   = string
    captcha_config = optional(object({
      immunity_time_property = object({
        immunity_time = number
      })
    }), null)
    rule_label = optional(list(string), null)
    statement  = any
    visibility_config = optional(object({
      cloudwatch_metrics_enabled = optional(bool)
      metric_name                = string
      sampled_requests_enabled   = optional(bool)
    }), null)
  }))
  default     = null
  description = <<-DOC
  A rule statement used to detect web requests coming from particular IP addresses or address ranges.

    action:
      The action that AWS WAF should take on a web request when it matches the rule's statement.
    name:
      A friendly name of the rule.
    priority:
      If you define more than one Rule in a WebACL,
      AWS WAF evaluates each request against the rules in order based on the value of priority.
      AWS WAF processes rules with lower priority first.

    captcha_config:
     Specifies how AWS WAF should handle CAPTCHA evaluations.

     immunity_time_property:
       Defines custom immunity time.

       immunity_time:
       The amount of time, in seconds, that a CAPTCHA or challenge timestamp is considered valid by AWS WAF. The default setting is 300.

    rule_label:
       A List of labels to apply to web requests that match the rule match statement
    statement:
      arn:
        The ARN of the IP Set that this statement references.
      ip_set:
        Defines a new IP Set

        description:
          A friendly description of the IP Set
        addresses:
          Contains an array of strings that specifies zero or more IP addresses or blocks of IP addresses.
          All addresses must be specified using Classless Inter-Domain Routing (CIDR) notation.
        ip_address_version:
          Specify `IPV4` or `IPV6`
      ip_set_forwarded_ip_config:
        fallback_behavior:
          The match status to assign to the web request if the request doesn't have a valid IP address in the specified position.
          Possible values: `MATCH`, `NO_MATCH`
        header_name:
          The name of the HTTP header to use for the IP address.
        position:
          The position in the header to search for the IP address.
          Possible values include: `FIRST`, `LAST`, or `ANY`.
    visibility_config:
      Defines and enables Amazon CloudWatch metrics and web request sample collection.

      cloudwatch_metrics_enabled:
        Whether the associated resource sends metrics to CloudWatch.
      metric_name:
        A friendly name of the CloudWatch metric.
      sampled_requests_enabled:
        Whether AWS WAF should store a sampling of the web requests that match the rules.
  DOC
}


variable "association_resource_arns" {
  type        = list(string)
  default     = []
  description = <<-DOC
    A list of ARNs of the resources to associate with the web ACL.
    This must be an ARN of an Application Load Balancer, Amazon API Gateway stage, or AWS AppSync.

    Do not use this variable to associate a Cloudfront Distribution.
    Instead, you should use the `web_acl_id` property on the `cloudfront_distribution` resource.
    For more details, refer to https://docs.aws.amazon.com/waf/latest/APIReference/API_AssociateWebACL.html
  DOC
  nullable    = false
}