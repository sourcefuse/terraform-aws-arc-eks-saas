locals {
  sts_caller_arn = data.aws_caller_identity.current.account_id
  eks_oidc_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}"
  oidc_arn       = replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")

  # set annotations to kuberhealthy deployment
  helm_settings = {
    "deployment.podAnnotations.prometheus\\.io/scrape" = true
    "deployment.podAnnotations.prometheus\\.io/port"   = "80"
    "deployment.podAnnotations.prometheus\\.io/scheme" = "http"
    "deployment.podAnnotations.prometheus\\.io/path"   = "/metrics"
  }
}