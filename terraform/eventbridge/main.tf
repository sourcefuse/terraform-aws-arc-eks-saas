################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

#################################################################################
## Eventbridge
#################################################################################
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"
  version = "3.7.1"
  bus_name = "${var.namespace}-${var.environment}-DecouplingEventBus"

  rules = {
    Decoupling-Event = {
      description   = "Decoupling Event Rule"
      event_pattern = jsonencode({ "detail-type": ["TENANT_PROVISIONING", "TENANT_DEPROVISIONING", "TENANT_PROVISIONING_SUCCESS"] })
      enabled       = true
    }
  }


  tags = module.tags.tags
}

resource "aws_cloudwatch_event_target" "api_gateway_target" {
  target_id = "APIGatewayTarget"
  rule      = "Decoupling-Event-rule"
  arn       = join("/",["${data.aws_ssm_parameter.api_gw_url.value}","${var.environment}","POST","*"])
  event_bus_name = "${var.namespace}-${var.environment}-DecouplingEventBus"
  http_target {
    path_parameter_values = ["$.detail-type"]
  }

}