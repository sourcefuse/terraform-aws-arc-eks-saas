################################################################################
## data lookups
################################################################################
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks_cluster" {
  name = "${var.namespace}-${var.environment}-eks-cluster"
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = "${var.namespace}-${var.environment}-eks-cluster"
}

data "aws_ssm_parameter" "prometheus_workspace_id" {
    name = "/${var.namespace}/${var.environment}/prometheus_workspace_id"
}