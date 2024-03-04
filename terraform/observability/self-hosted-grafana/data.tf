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



provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster_auth.token
    #load_config_file       = false
  }
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  #load_config_file       = false
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  #load_config_file       = false
}

################################################################################
## iam policy data
################################################################################
data "aws_iam_policy_document" "grafana_eks_policy" {

  statement {
    sid    = "GrafanaEKSPolicy"
    effect = "Allow"
    actions = [
      "aps:RemoteWrite",
      "aps:GetSeries",
      "aps:GetLabels",
      "aps:GetMetricMetadata"
    ]
    resources = ["*"]
  }
}

# data "aws_iam_policy_document" "prometheus_eks_policy" {

#   statement {
#     sid    = "PrometheusEKSPolicy"
#     effect = "Allow"
#     actions = [
#       "aps:*",
#       "eks:DescribeCluster",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups"
#     ]
#     resources = ["*"]
#   }
# }