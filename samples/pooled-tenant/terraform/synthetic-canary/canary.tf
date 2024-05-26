// SNS Topic for Canary Alerting
resource "aws_sns_topic" "canary_updates" {
  name            = "${var.tenant}-canary-updates-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  tags            = module.tags.tags
}

resource "aws_sns_topic_subscription" "canary_update_subscription" {
  topic_arn = aws_sns_topic.canary_updates.id
  protocol  = "email"
  endpoint  = var.tenant_email
}


// Setup for one Canary. This section can be reused several time.
module "canary" {
  source            = "../../modules/canary"
  name              = "${var.tenant}-canary-run"
  runtime_version   = var.runtime_version
  take_screenshot   = var.take_screenshot
  api_hostname      = "https://${var.tenant_host_domain}"
  api_path          = var.api_path
  reports-bucket    = data.aws_ssm_parameter.canary_report_bucket.value
  role              = data.aws_ssm_parameter.canary_role.value
  security_group_id = data.aws_ssm_parameter.canary_security_group.value
  subnet_ids        = data.aws_subnets.private.ids
  frequency         = var.frequency
  alert_sns_topic   = aws_sns_topic.canary_updates.id
  tags              = module.tags.tags
}