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
  }
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

################################################################################
## prometheus service account policy
################################################################################
data "aws_iam_policy_document" "prometheus_sa_policy" {

  statement {
    sid    = "PrometheusServiceAccountPolicy"
    effect = "Allow"
    actions = [
      "aps:*"
    ]
    resources = ["*"]
  }
}