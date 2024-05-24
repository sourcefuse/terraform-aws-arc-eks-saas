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
}

resource "aws_sns_topic_subscription" "canary_update_subscription" {
  topic_arn = aws_sns_topic.canary_updates.id
  protocol  = "email"
  endpoint  = var.tenant_email
}

// Setup of the common Infrastructure
module "canary_infra" {
    source = "../modules/canary-infra"
    vpc_id = [data.aws_vpc.vpc.cidr_block]
    subnet_ids = data.aws_subnets.private.ids
}

// Setup for one Canary. This section can be reused several time.
module "canary" {
    source = "../modules/canary"
    name   = "${var.tenant}-synthetic-canary"
    runtime_version = var.runtime_version
    take_screenshot = var.take_screenshot
    api_hostname = "https://${tenant_host_domain}"
    api_path = var.api_path
    reports-bucket = module.canary_infra.reports-bucket
    role = module.canary_infra.role
    security_group_id = module.canary_infra.security_group_id
    subnet_ids = data.aws_subnets.private.ids
    frequency = var.frequency
    alert_sns_topic = aws_sns_topic.canary_updates.id
}