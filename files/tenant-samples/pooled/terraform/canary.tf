resource "aws_synthetics_canary" "main" {
  count                = var.canary_enabled ? 1 : 0
  name                 = "${var.tenant_tier}-${var.tenant}"
  artifact_s3_location = "s3://${data.aws_ssm_parameter.canary_report_bucket.value}/${var.tenant_tier}-${var.tenant}-canary"
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
    content = templatefile("${path.module}/templates/canary_node.tmpl", {
      api_hostname    = "https://${var.tenant_host_domain}"
      api_path        = var.api_path
      take_screenshot = var.take_screenshot
    })
    filename = "nodejs/node_modules/apiCanaryBlueprint.js"
  }
}