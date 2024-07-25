################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

################################################################################
## Lambda
################################################################################
module "lambda_function_container_image" {
  source = "terraform-aws-modules/lambda/aws"
  version = "7.6.0"

  function_name = "${var.namespace}-${var.environment}-decoupling-orchestrator-function"
  description   = "Orchestrator Function for Decoupling events"

  create_package = false

  image_uri    = data.aws_ssm_parameter.orchestrator_ecr_image.value
  timeout = var.timeout
  memory_size = var.memory_size
  ephemeral_storage_size = var.ephemeral_storage_size
  package_type = "Image"
  architectures = var.compatible_architectures 

  environment_variables = {
    TIER_DETAILS_TABLE = "${var.namespace}-${var.environment}-decoupling-tier-map-table"
  }

  attach_policies    = true
  policies           = ["arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess","arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess","arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator","arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"]
  tags = module.tags.tags  
}

####################################################################################
## Api Gateway
####################################################################################
module "api_gateway" {
  source  = "cloudposse/api-gateway/aws"
  version = "0.7.0"
  name = "${var.namespace}-${var.environment}-decoupling-api-gw"
  stage_name = "${var.environment}"
  
  openapi_config = {
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }

    paths = {
      "/events/{eventType}" = {
        post = {
          "x-amazon-apigateway-auth": {
          "type": "AWS_IAM"
           },
          "x-amazon-apigateway-integration" = {
               "responses" = {
                  "default" = {
                     "statusCode" = "200"
                  }
               },
               "uri" = module.lambda_function_container_image.lambda_function_invoke_arn,
               "passthroughBehavior" = "when_no_match",
               "httpMethod" = "POST",
               "type": "aws_proxy"              
            }
        }

      }
    }
  }
  logging_level = var.logging_level
  tags = module.tags.tags
}

###########################################################################
## Store API gateway ARN to SSM Parameter
###########################################################################
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
