################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

#########################################################################################
## DynamoDB Table for decoupling tier map
#########################################################################################
locals {
  dynamo_kms_master_key_id = var.dynamo_kms_master_key_id == null ? "" : var.dynamo_kms_master_key_id
}

resource "aws_dynamodb_table" "tier_mapping" {
  name           = "${var.namespace}-${var.environment}-decoupling-tier-map-table"
  hash_key       = var.dynamodb_hash_key
  read_capacity  = 5
  write_capacity = 5

  server_side_encryption {
    enabled     = true
    kms_key_arn = local.dynamo_kms_master_key_id
  }

  attribute {
    name = var.dynamodb_hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.enable_dynamodb_point_in_time_recovery
  }

  tags = merge(module.tags.tags, tomap({
    Name = "${var.namespace}-${var.environment}-decoupling-tier-map-table",
  }))
}

resource "aws_dynamodb_table" "orchestrator_data_store" {
  name           = "${var.namespace}-${var.environment}-orchestrator-service-data-store"
  hash_key       = "tenantId"
  read_capacity  = 5
  write_capacity = 5

  server_side_encryption {
    enabled     = true
    kms_key_arn = local.dynamo_kms_master_key_id
  }

  attribute {
    name = "tenantId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.enable_dynamodb_point_in_time_recovery
  }

  tags = merge(module.tags.tags, tomap({
    Name = "${var.namespace}-${var.environment}-orchestrator-service-data-store",
  }))
}

## Store details in the mapping dynamodb table

resource "aws_dynamodb_table_item" "basic" {
  table_name = aws_dynamodb_table.tier_mapping.name
  hash_key   = aws_dynamodb_table.tier_mapping.hash_key

  item = <<ITEM
{
  "tier": {"S": "BASIC"},
  "EKS_CLUSTER_NAME": {"S": "${var.namespace}-${var.environment}-eks-cluster"},
  "jobName": {"S": "${var.namespace}-${var.environment}-basic-codebuild-project"},
  "KARPENTER_ROLE": {"S": "${data.aws_ssm_parameter.karpenter_role.value}"},
  "VPC_ID": {"S": "${data.aws_vpc.vpc.id}"},
  "AWS_ACCOUNT_ID": {"S": "${data.aws_caller_identity.current.account_id}"},
  "AWS_REGION": {"S": "${var.region}"},
  "NAMESPACE": {"S": "${var.namespace}"},
  "ENVIRONMENT": {"S": "${var.environment}"},
  "VPC_CIDR_BLOCK": {"S": "${data.aws_vpc.vpc.cidr_block}"},
  "EVENT_BUS_NAME": {"S": "${var.namespace}-${var.environment}-DecouplingEventBus"},
  "CB_ROLE": {"S": "${data.aws_ssm_parameter.codebuild_role.value}"},
  "DOMAIN_NAME": {"S": "${var.domain_name}"},
  "CONTROL_PLANE_HOST": {"S": "${var.control_plane_host}"},
  "ACCESS_TOKEN_EXPIRATION": {"N": "3600"},
  "REFRESH_TOKEN_EXPIRATION": {"N": "3600"},
  "AUTH_CODE_EXPIRATION": {"N": "3600"}
}
ITEM
}

resource "aws_dynamodb_table_item" "standard" {
  table_name = aws_dynamodb_table.tier_mapping.name
  hash_key   = aws_dynamodb_table.tier_mapping.hash_key

  item = <<ITEM
{
  "tier": {"S": "STANDARD"},
  "EKS_CLUSTER_NAME": {"S": "${var.namespace}-${var.environment}-eks-cluster"},
  "jobName": {"S": "${var.namespace}-${var.environment}-standard-codebuild-project"},
  "KARPENTER_ROLE": {"S": "${data.aws_ssm_parameter.karpenter_role.value}"},
  "VPC_ID": {"S": "${data.aws_vpc.vpc.id}"},
  "AWS_ACCOUNT_ID": {"S": "${data.aws_caller_identity.current.account_id}"},
  "AWS_REGION": {"S": "${var.region}"},
  "NAMESPACE": {"S": "${var.namespace}"},
  "ENVIRONMENT": {"S": "${var.environment}"},
  "VPC_CIDR_BLOCK": {"S": "${data.aws_vpc.vpc.cidr_block}"},
  "EVENT_BUS_NAME": {"S": "${var.namespace}-${var.environment}-DecouplingEventBus"},
  "CB_ROLE": {"S": "${data.aws_ssm_parameter.codebuild_role.value}"},
  "DOMAIN_NAME": {"S": "${var.domain_name}"},
  "CONTROL_PLANE_HOST": {"S": "${var.control_plane_host}"},
  "ACCESS_TOKEN_EXPIRATION": {"N": "3600"},
  "REFRESH_TOKEN_EXPIRATION": {"N": "3600"},
  "AUTH_CODE_EXPIRATION": {"N": "3600"}
}
ITEM
}

resource "aws_dynamodb_table_item" "premium" {
  table_name = aws_dynamodb_table.tier_mapping.name
  hash_key   = aws_dynamodb_table.tier_mapping.hash_key

  item = <<ITEM
{
  "tier": {"S": "PREMIUM"},
  "EKS_CLUSTER_NAME": {"S": "${var.namespace}-${var.environment}-eks-cluster"},
  "jobName": {"S": "${var.namespace}-${var.environment}-premium-codebuild-project"},
  "KARPENTER_ROLE": {"S": "${data.aws_ssm_parameter.karpenter_role.value}"},
  "VPC_ID": {"S": "${data.aws_vpc.vpc.id}"},
  "AWS_ACCOUNT_ID": {"S": "${data.aws_caller_identity.current.account_id}"},
  "AWS_REGION": {"S": "${var.region}"},
  "NAMESPACE": {"S": "${var.namespace}"},
  "ENVIRONMENT": {"S": "${var.environment}"},
  "VPC_CIDR_BLOCK": {"S": "${data.aws_vpc.vpc.cidr_block}"},
  "EVENT_BUS_NAME": {"S": "${var.namespace}-${var.environment}-DecouplingEventBus"},
  "CB_ROLE": {"S": "${data.aws_ssm_parameter.codebuild_role.value}"},
  "DOMAIN_NAME": {"S": "${var.domain_name}"},
  "CONTROL_PLANE_HOST": {"S": "${var.control_plane_host}"},
  "ACCESS_TOKEN_EXPIRATION": {"N": "3600"},
  "REFRESH_TOKEN_EXPIRATION": {"N": "3600"},
  "AUTH_CODE_EXPIRATION": {"N": "3600"}
}
ITEM
}

##################################################################################
## Lambda & API GW for Decoupling
##################################################################################
module "lambda_function_container_image" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.6.0"

  function_name = "${var.namespace}-${var.environment}-decoupling-orchestrator-function"
  description   = "Orchestrator Function for Decoupling events"

  create_package = false

  image_uri              = data.aws_ssm_parameter.orchestrator_ecr_image.value
  timeout                = var.timeout
  memory_size            = var.memory_size
  ephemeral_storage_size = var.ephemeral_storage_size
  package_type           = "Image"
  architectures          = var.compatible_architectures
  maximum_retry_attempts = var.maximum_retry_attempts

  environment_variables = {
    TIER_DETAILS_TABLE   = "${var.namespace}-${var.environment}-decoupling-tier-map-table"
    EVENT_BUS_AWS_REGION = "${var.region}"
    EVENT_BUS_NAME       = "${var.namespace}-${var.environment}-DecouplingEventBus"
    DATA_STORE_TABLE     = "${var.namespace}-${var.environment}-orchestrator-service-data-store"
    DYNAMO_DB_REGION     = "${var.region}"
  }

  publish            = true
  attach_policies    = true
  number_of_policies = 4
  policies           = ["arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess", "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess", "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator", "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"]
  tags               = module.tags.tags

  allowed_triggers = {
    APIGatewayAny = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:*"
    }
  }
}

## Api Gateway
module "api_gateway" {
  source     = "cloudposse/api-gateway/aws"
  version    = "0.7.0"
  name       = "${var.namespace}-${var.environment}-decoupling-api-gw"
  stage_name = var.environment

  openapi_config = {
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }

    paths = {
      "/events/{eventType}" = {
        post = {
          "x-amazon-apigateway-auth" : {
            "type" : "AWS_IAM"
          },
          "x-amazon-apigateway-integration" = {
            "responses" = {
              "default" = {
                "statusCode" = "200"
              }
            },
            "uri"                 = module.lambda_function_container_image.lambda_function_invoke_arn,
            "passthroughBehavior" = "when_no_match",
            "httpMethod"          = "POST",
            "type" : "aws_proxy"
          }
        }

      }
    }
  }
  logging_level = var.logging_level
  tags          = module.tags.tags
  depends_on    = [module.lambda_function_container_image]
}

## Store API gateway ARN to SSM Parameter

module "api_gw_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/api_gw_arn"
      value       = module.api_gateway.execution_arn
      type        = "String"
      overwrite   = "true"
      description = "API-Gateway arn"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.api_gateway]
}

###############################################################################
## Eventbridge
###############################################################################
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
  name              = "${var.namespace}/${var.environment}/aws/events/decoupling-events/logs"
  retention_in_days = 7
}

module "eventbridge" {
  source                   = "terraform-aws-modules/eventbridge/aws"
  version                  = "3.7.1"
  bus_name                 = "${var.namespace}-${var.environment}-DecouplingEventBus"
  attach_cloudwatch_policy = true
  rules = {
    Decoupling-Event = {
      description   = "Decoupling Event Rule"
      event_pattern = jsonencode({ "detail-type" : ["TENANT_PROVISIONING", "TENANT_DEPROVISIONING", "TENANT_PROVISIONING_SUCCESS", "TENANT_PROVISIONING_FAILURE", "TENANT_DEPLOYMENT", "TENANT_DEPLOYMENT_SUCCESS", "TENANT_DEPLOYMENT_FAILURE"] })
      enabled       = true
    }
  }

  targets = {
    Decoupling-Event = [
      {
        name = "send-logs-to-cloudwatch"
        arn  = aws_cloudwatch_log_group.decoupling_log_group.arn

      }
    ]
  }
  cloudwatch_target_arns = ["${aws_cloudwatch_log_group.decoupling_log_group.arn}"]

  tags = module.tags.tags
}


resource "aws_cloudwatch_event_target" "api_gateway_target" {
  target_id      = "APIGatewayTarget"
  rule           = "Decoupling-Event-rule"
  arn            = join("/", ["${data.aws_ssm_parameter.api_gw_url.value}", "${var.environment}", "POST", "events", "*"])
  event_bus_name = "${var.namespace}-${var.environment}-DecouplingEventBus"
  role_arn       = module.eventbridge_role.arn
  http_target {
    path_parameter_values = ["$.detail-type"]
  }
  depends_on = [module.api_gateway, module.api_gw_ssm_parameters]
}