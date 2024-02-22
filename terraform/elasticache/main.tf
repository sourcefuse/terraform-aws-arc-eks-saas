##############################################################################
##Default
##############################################################################
terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

##############################################################################
##Tags
##############################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

###############################################################################
##Elasticache
###############################################################################
module "ec_security_group" {
  source = "../../modules/security-group"

  security_group_name        = "${var.namespace}-${var.environment}-redis-security-group"
  security_group_description = "Elasticache Redis Security Group"
  vpc_id                     = data.aws_vpc.vpc.id
  ingress_rules = {
    rule1 = {
      description = "Rule to allow Redis users to access the Redis cluster"
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = [data.aws_vpc.vpc.cidr_block]
    }
  }
  egress_rules = {
    rule1 = {
      description = "outgoing traffic to anywhere"
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # -1 signifies all protocols
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = merge(module.tags.tags, tomap({ Attribute = "redis" }))
}

module "redis_password" {
  source           = "../../modules/random-password"
  length           = 18
  is_special       = true
  override_special = "!#@"
}

module "redis" {
  source  = "cloudposse/elasticache-redis/aws"
  version = "1.2.0"

  namespace                        = var.namespace
  environment                      = var.environment
  vpc_id                           = data.aws_vpc.vpc.id
  associated_security_group_ids    = module.ec_security_group.id
  create_security_group            = false
  subnets                          = data.aws_subnets.private.ids
  maintenance_window               = var.maintenance_window
  apply_immediately                = var.apply_immediately
  at_rest_encryption_enabled       = var.at_rest_encryption_enabled
  transit_encryption_enabled       = var.transit_encryption_enabled
  cluster_size                     = var.cluster_size
  family                           = var.family
  instance_type                    = var.instance_type
  engine_version                   = var.engine_version
  cluster_mode_enabled             = var.cluster_mode_enabled
  auth_token                       = var.auth_token
  snapshot_window                  = var.snapshot_window
  snapshot_retention_limit         = var.snapshot_retention_limit
  automatic_failover_enabled       = var.automatic_failover_enabled
  multi_az_enabled                 = var.multi_az_enabled
  description                      = "Elasticache Redis instance for ${var.namespace}-${var.environment}"
  cloudwatch_metric_alarms_enabled = var.cloudwatch_metric_alarms_enabled
  depends_on                       = [module.ec_security_group]
  tags                             = module.tags.tags
  context                          = module.this.context
}

###########################################################################
## store redis endpoint in ssm parameter store
###########################################################################
module "ssm_redis_host" {
  source                    = "../../modules/ssm-parameter"
  ssm_parameter_name        = "/${var.namespace}/${var.environment}/redis_host"
  ssm_parameter_description = "Redis host"
  ssm_parameter_type        = "SecureString"
  ssm_parameter_overwrite   = true
  ssm_parameter_value       = module.redis.endpoint
  tags                      = module.tags.tags
  depends_on                = [module.redis]
}

module "ssm_redis_port" {
  source                    = "../../modules/ssm-parameter"
  ssm_parameter_name        = "/${var.namespace}/${var.environment}/redis_port"
  ssm_parameter_description = "Redis Port"
  ssm_parameter_type        = "SecureString"
  ssm_parameter_overwrite   = true
  ssm_parameter_value       = var.redis_port
  tags                      = module.tags.tags
  depends_on                = [module.redis]
}

module "ssm_redis_password" {
  source                    = "../../modules/ssm-parameter"
  ssm_parameter_name        = "/${var.namespace}/${var.environment}/redis-password"
  ssm_parameter_description = "Redis Password"
  ssm_parameter_type        = "SecureString"
  ssm_parameter_overwrite   = true
  ssm_parameter_value       = module.redis_password.result
  tags                      = module.tags.tags
  depends_on                = [module.redis]
}

module "ssm_redis_database" {
  source                    = "../../modules/ssm-parameter"
  ssm_parameter_name        = "/${var.namespace}/${var.environment}/redis-database"
  ssm_parameter_description = "Redis Database"
  ssm_parameter_type        = "SecureString"
  ssm_parameter_overwrite   = true
  ssm_parameter_value       = var.redis_database
  tags                      = module.tags.tags
  depends_on                = [module.redis]
}
