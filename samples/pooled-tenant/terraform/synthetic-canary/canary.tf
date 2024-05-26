# // SNS Topic for Canary Alerting
# resource "aws_sns_topic" "canary_updates" {
#   name            = "${var.tenant}-canary-updates-topic"
#   delivery_policy = <<EOF
# {
#   "http": {
#     "defaultHealthyRetryPolicy": {
#       "minDelayTarget": 20,
#       "maxDelayTarget": 20,
#       "numRetries": 3,
#       "numMaxDelayRetries": 0,
#       "numNoDelayRetries": 0,
#       "numMinDelayRetries": 0,
#       "backoffFunction": "linear"
#     },
#     "disableSubscriptionOverrides": false,
#     "defaultThrottlePolicy": {
#       "maxReceivesPerSecond": 1
#     }
#   }
# }
# EOF
#   tags            = module.tags.tags
# }

# resource "aws_sns_topic_subscription" "canary_update_subscription" {
#   topic_arn = aws_sns_topic.canary_updates.id
#   protocol  = "email"
#   endpoint  = var.tenant_email
# }


# // Setup for one Canary. This section can be reused several time.
# module "canary" {
#   source            = "../../modules/canary"
#   name              = "${var.tenant}-canary-run"
#   runtime_version   = var.runtime_version
#   take_screenshot   = var.take_screenshot
#   api_hostname      = "https://${var.tenant_host_domain}"
#   api_path          = var.api_path
#   reports-bucket    = data.aws_ssm_parameter.canary_report_bucket.value
#   role              = data.aws_ssm_parameter.canary_role.value
#   security_group_id = data.aws_ssm_parameter.canary_security_group.value
#   subnet_ids        = data.aws_subnets.private.ids
#   frequency         = var.frequency
#   alert_sns_topic   = aws_sns_topic.canary_updates.id
#   tags              = module.tags.tags
# }


resource "aws_synthetics_canary" "main" {
  name                 = "${var.tenant}-canary"
  artifact_s3_location = "s3://${data.aws_ssm_parameter.canary_report_bucket.value}/${var.tenant}-canary"
  execution_role_arn   = data.aws_ssm_parameter.canary_role.value
  handler              = "apiCanaryBlueprint.handler"
  start_canary         = true
  zip_file             = "/tmp/canary_zip_inline.zip"
  runtime_version      = "syn-nodejs-puppeteer-7.0"
  
  # VPC Config
  # vpc_config {
  #   subnet_ids         = 
  #   security_group_ids = 
  # }

  #   run_config {
  #   active_tracing = true
  #   timeout_in_seconds = 60
  # }

  schedule {
    expression = "rate(6 minutes)"
  }

}

data "archive_file" "canary_zip_inline" {
  type        = "zip"
  output_path = "/tmp/canary_zip_inline.zip"
  
  source {
    content  = templatefile("${path.module}/templates/canary_node.tmpl", {
      endpoint = "https://${var.tenant_host_domain}/main/home"
      hostname = "https://${var.tenant_host_domain}"
      endpointpath = var.endpointpath
      port = var.port
    })
    filename = "nodejs/node_modules/apiCanaryBlueprint.js"
  }
}