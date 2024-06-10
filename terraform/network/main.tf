################################################################
## Tag
################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

################################################################
## Network
################################################################
module "network" {
  source  = "sourcefuse/arc-network/aws"
  version = "2.6.10"

  environment = var.environment
  namespace   = var.namespace

  availability_zones          = var.availability_zones
  vpc_ipv4_primary_cidr_block = var.vpc_ipv4_primary_cidr_block

  client_vpn_authorization_rules = var.client_vpn_authorization_rules
  custom_subnets_enabled         = var.is_custom_subnet_enabled
  client_vpn_enabled             = var.client_vpn_enabled
  vpc_endpoints_enabled          = var.vpc_endpoints_enabled


  vpc_endpoint_config = {
    s3         = var.enable_s3_endpoint
    kms        = var.enable_kms_endpoint
    cloudwatch = var.enable_cloudwatch_endpoint
    elb        = var.enable_elb_endpoint
    dynamodb   = var.enable_dynamodb_endpoint
    ec2        = var.enable_ec2_endpoint
    sns        = var.enable_sns_endpoint
    sqs        = var.enable_sqs_endpoint
    ecs        = var.enable_ecs_endpoint
    rds        = var.enable_rds_endpoint
  }

  custom_nat_gateway_enabled          = var.custom_nat_gateway_enabled
  gateway_endpoint_route_table_filter = ["*private*"]

  custom_private_subnets = [
    for idx in range(var.private_subnet_count) : {
      name              = "${var.namespace}-${var.environment}-private-subnet-private-${var.region}${element(["a", "b", "c", "d", "e"], idx)}"
      availability_zone = "${var.region}${element(["a", "b", "c", "d", "e"], idx)}"
      cidr_block        = var.custom_private_subnet_ids[idx]
    }
  ]
  custom_public_subnets = [
    for idx in range(var.public_subnet_count) : {
      name              = "${var.namespace}-${var.environment}-public-subnet-public-${var.region}${element(["a", "b", "c", "d", "e"], idx)}"
      availability_zone = "${var.region}${element(["a", "b", "c", "d", "e"], idx)}"
      cidr_block        = var.custom_public_subnet_ids[idx]
    }
  ]

  tags = module.tags.tags
}

#######################################################################
## Security Group
#######################################################################
module "allow_database_connection_security_group" {
  source = "../../modules/security-group"

  security_group_name        = "${var.namespace}-${var.environment}-codebuild-db-access"
  security_group_description = "Allow Database inbound traffic"
  vpc_id                     = module.network.vpc_id
  ingress_rules = {
    rule1 = {
      description = "Rule to allow to access the data base"
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = [var.vpc_ipv4_primary_cidr_block]
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
  tags = merge(module.tags.tags, tomap({ Name = "${var.namespace}-${var.environment}-codebuild-db-access" }))
}