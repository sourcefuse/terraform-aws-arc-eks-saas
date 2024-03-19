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

# resource "helm_release" "prometheus_blackbox_exporter" {

#   name             = "prometheus-blackbox-exporter"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "prometheus-blackbox-exporter"
#   version          = "8.12.0"
#   namespace        = "adot-collector-kubeprometheus"
#   create_namespace = false

#   set {
#     name = "ServiceMonitor.selfMonitor.enabled"
#     value = true
#   }
# }
# data "local_file" "kuberhealthy_chart" {
#   depends_on = [helm_provider.kubernetes]
#   filename   = "${path.module}/kuberhealthy_chart.tar.gz"
#   source     = "https://github.com/kuberhealthy/kuberhealthy/archive/refs/heads/master.tar.gz"
# }

# data "archive_file" "kuberhealthy_chart" {
#   depends_on = [data.local_file.kuberhealthy_chart]
#   source_dir  = data.local_file.kuberhealthy_chart.content_path
#   output_path = "${path.module}/kuberhealthy_chart.tar.gz"
# }

resource "helm_release" "kuberhealthy" {
  name       = "kuberhealthy"
  repository = "https://kuberhealthy.github.io/kuberhealthy/helm-repos"
  chart      = "kuberhealthy"
  version    = "104"
  namespace  = "kuberhealthy"  # Specify the namespace where you want to deploy
  create_namespace = true

  set {
    name  = "check.daemonset.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "dnsExternal.enabled"
    value = true
  }

  set {
    name  = "podRestarts.enabled"
    value = true
  }

  set {
    name  = "podRestarts.allNamespaces"
    value = true
  }

  set {
    name = "podStatus.enabled"
    value = true
  }

  set {
    name = "deployment.replicas"
    value = 1
  }

  set {
    name = "prometheus.prometheusRule.enabled"
    value = true
  }
}