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
module "eventbridge_role" {
  source           = "../../modules/iam-role"
  role_name        = "terraform-eventbridge-role-${var.namespace}-${var.environment}"
  role_description = "terraform eventbridge role"
  principals = {
    "Service" : ["events.amazonaws.com",
                "delivery.logs.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "terraform-eventbridge-policy-${var.namespace}-${var.environment}"
  policy_description = "terraform eventbridge policy"
  tags               = module.tags.tags
}

# cloudwatch log group
resource "aws_cloudwatch_log_group" "decoupling_log_group" {
  name              = "/aws/events/decoupling-events/logs"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "decoupling_log_stream" {
  name           = "EventbridgeLogs"
  log_group_name = aws_cloudwatch_log_group.decoupling_log_group.name
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"
  version = "3.7.1"
  bus_name = "${var.namespace}-${var.environment}-DecouplingEventBus"
  attach_cloudwatch_policy = true
  rules = {
    Decoupling-Event = {
      description   = "Decoupling Event Rule"
      event_pattern = jsonencode({ "detail-type": ["TENANT_PROVISIONING", "TENANT_DEPROVISIONING", "TENANT_PROVISIONING_SUCCESS"] })
      enabled       = true
    }
  }

  targets = {
    Decoupling-Event = [
        {
          name =   "send-logs-to-cloudwatch"
          arn       = aws_cloudwatch_log_group.decoupling_log_group.arn
    
        }
    ]
  }
  cloudwatch_target_arns = ["${aws_cloudwatch_log_group.decoupling_log_group.arn}"]

  tags = module.tags.tags
}


resource "aws_cloudwatch_event_target" "api_gateway_target" {
  target_id = "APIGatewayTarget"
  rule      = "Decoupling-Event-rule"
  arn       = join("/",["${data.aws_ssm_parameter.api_gw_url.value}","${var.environment}","POST","events","*"])
  event_bus_name = "${var.namespace}-${var.environment}-DecouplingEventBus"
  role_arn  = module.eventbridge_role.arn
  http_target {
    path_parameter_values = ["$.detail-type"]
  }

}