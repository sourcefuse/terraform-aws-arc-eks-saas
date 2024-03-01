#############################################################################
## default
#############################################################################
terraform {
  required_version = ">= 1.4"

  backend "s3" {}

}


provider "aws" {
  region = var.region
}

module "istio" {
  source = "../../modules/istio"

  eks_cluster_name       = "${var.namespace}-${var.environment}-eks-cluster"
  istio_base_version     = "1.19.6"
  istiod_version         = "1.19.6"
  istio_ingress_version  = "1.19.6"
  istio_ingress_min_pods = var.min_pods
  istio_ingress_max_pods = var.max_pods
  deploy_kiali           = true
  kiali_server_version   = "1.78.0"

  common_name  = var.common_name
  organization = var.organization

  alb_ingress_name    = var.alb_ingress_name
  acm_certificate_arn = var.acm_certificate_arn
  domain_name         = var.domain_name

}


resource "null_resource" "apply_manifests" {
  depends_on = [module.istio]

  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
   // when    = create
    command = "ls -la"
  }

  provisioner "local-exec" {
    //when    = create
    command = "kubectl apply -f ${path.module}/manifest-files/istio_gateway.yaml"
  }

  provisioner "local-exec" {
   // when    = create
    command = "kubectl apply -f ${path.module}/manifest-files/k8s_ingress.yaml"
  }
}