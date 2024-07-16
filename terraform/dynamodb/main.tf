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
resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.tier_mapping.name
  hash_key   = aws_dynamodb_table.tier_mapping.hash_key

  item = <<ITEM
{
  "tier": {"S": "STANDARD"},
  "eksClusterName": {"S": "${var.namespace}-${var.environment}-eks-cluster"},
  "jobName": {"S": "${var.namespace}-${var.environment}-standard-codebuild-project"},
  "karpenterRole": {"S": "${data.aws_ssm_parameter.karpenter_role.value}"},
  "vpcId": {"S": "${data.aws_vpc.vpc.id}"}
},
{
  "tier": {"S": "PREMIUM"},
  "eksClusterName": {"S": "${var.namespace}-${var.environment}-eks-cluster"},
  "jobName": {"S": "${var.namespace}-${var.environment}-premium-codebuild-project"},
  "karpenterRole": {"S": "${data.aws_ssm_parameter.karpenter_role.value}"},
  "vpcId": {"S": "${data.aws_vpc.vpc.id}"}
},
{
  "tier": {"S": "BASIC"},
  "eksClusterName": {"S": "${var.namespace}-${var.environment}-eks-cluster"},
  "jobName": {"S": "${var.namespace}-${var.environment}-basic-codebuild-project"},
  "karpenterRole": {"S": "${data.aws_ssm_parameter.karpenter_role.value}"},
  "vpcId": {"S": "${data.aws_vpc.vpc.id}"}
}
ITEM
}