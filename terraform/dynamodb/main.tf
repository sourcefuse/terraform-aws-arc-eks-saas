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

###################################################################################
## Store details in the mapping dynamodb table
###################################################################################
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
  "SUBNET_IDS": {"SS": ${jsonencode(data.aws_subnets.private.ids)}},
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
  "SUBNET_IDS": {"SS": ${jsonencode(data.aws_subnets.private.ids)}},
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
  "SUBNET_IDS": {"SS": ${jsonencode(data.aws_subnets.private.ids)}},
  "CB_ROLE": {"S": "${data.aws_ssm_parameter.codebuild_role.value}"},
  "DOMAIN_NAME": {"S": "${var.domain_name}"},
  "CONTROL_PLANE_HOST": {"S": "${var.control_plane_host}"},
  "ACCESS_TOKEN_EXPIRATION": {"N": "3600"},
  "REFRESH_TOKEN_EXPIRATION": {"N": "3600"},
  "AUTH_CODE_EXPIRATION": {"N": "3600"}
}
ITEM
}