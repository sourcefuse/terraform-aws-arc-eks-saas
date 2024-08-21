###############################################################################
##Elasticache
###############################################################################
module "ec_security_group" {
  source = "../../modules/security-group"

  security_group_name        = "${var.namespace}-${var.environment}-${var.tenant_tier}-redis-security-group"
  security_group_description = "Elasticache Redis Security Group for ${var.tenant_tier} tenants"
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
  tags = module.tags.tags
}

module "redis" {
  source  = "cloudposse/elasticache-redis/aws"
  version = "1.2.0"

  namespace                        = var.namespace
  environment                      = var.environment
  name                             = "${var.tenant_tier}-redis"
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
  description                      = "Elasticache Redis instance for ${var.namespace}-${var.environment}-${var.tenant_tier}-tenants"
  cloudwatch_metric_alarms_enabled = var.cloudwatch_metric_alarms_enabled
  depends_on                       = [module.ec_security_group]
  tags                             = module.tags.tags

}

###########################################################################
## store redis endpoint in ssm parameter store
###########################################################################
module "redis_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/redis_host"
      value       = module.redis.endpoint
      type        = "SecureString"
      overwrite   = "true"
      description = "Redis Host"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/redis_port"
      value       = var.redis_port
      type        = "SecureString"
      overwrite   = "true"
      description = "Redis Port"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/redis-database"
      value       = var.redis_database
      type        = "SecureString"
      overwrite   = "true"
      description = "Redis Database"
    }
  ]
  tags       = module.tags.tags
  depends_on = [module.redis]
}