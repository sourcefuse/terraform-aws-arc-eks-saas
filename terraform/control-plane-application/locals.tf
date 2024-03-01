locals {
  sts_caller_arn = data.aws_caller_identity.current.account_id
  oidc_arn       = replace(data.aws_eks_cluster.EKScluster.identity[0].oidc[0].issuer, "https://", "")
  kubernetes_ns  = "control-plane"
}
