################################################################################
## shared
################################################################################
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
}

variable "domain_name" {
  type        = string
  description = "Domain Name for the SAAS Application"
}

################################################################################
## billing
################################################################################
variable "budgets" {
  type        = any
  description = <<-EOF
  A list of Budgets to create.
  EOF
  default     = []
}

variable "notifications_enabled" {
  type        = bool
  description = "Whether or not to setup Slack notifications. Set to `true` to create an SNS topic and Lambda function to send alerts to Slack."
  default     = false
}

variable "encryption_enabled" {
  type        = bool
  description = "Whether or not to use encryption. If set to `true` and no custom value for KMS key (kms_master_key_id) is provided, a KMS key is created."
  default     = true
}

variable "slack_webhook_url" {
  type        = string
  description = "The URL of Slack webhook. Only used when `notifications_enabled` is `true`"
  default     = ""
}

variable "slack_channel" {
  type        = string
  description = "The name of the channel in Slack for notifications. Only used when `notifications_enabled` is `true`"
  default     = ""
}

variable "slack_username" {
  type        = string
  description = "The username that will appear on Slack messages. Only used when `notifications_enabled` is `true`"
  default     = ""
}

variable "billing_alerts_sns_subscribers" {
  type = map(object({
    protocol               = string
    endpoint               = string
    endpoint_auto_confirms = bool
    raw_message_delivery   = bool
  }))
  description = <<-DOC
  A map of subscription configurations for SNS topics

  For more information, see:
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription#argument-reference

  protocol:
    The protocol to use. The possible values for this are: sqs, sms, lambda, application. (http or https are partially
    supported, see link) (email is an option but is unsupported in terraform, see link).
  endpoint:
    The endpoint to send data to, the contents will vary with the protocol. (see link for more information)
  endpoint_auto_confirms:
    Boolean indicating whether the end point is capable of auto confirming subscription e.g., PagerDuty. Default is
    false
  raw_message_delivery:
    Boolean indicating whether or not to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property).
    Default is false
  DOC
  default     = null
}
