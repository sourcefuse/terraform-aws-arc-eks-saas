################################################################################
## defaults
################################################################################
provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.EKScluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.EKScluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.EKScluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.EKScluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.EKScluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.EKScluster.token
  }
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.EKScluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.EKScluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.EKScluster.token
}
