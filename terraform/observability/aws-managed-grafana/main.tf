############################################################################
## provider
############################################################################
terraform {
  required_providers {
    aws = {
      source  = "aws"
      version = "5.4.0"
    }
    helm = {
      source  = "helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "kubernetes"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    tls = {
      source  = "tls"
      version = "~> 3.1.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 2.9.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

############################################################################
## Grafana
############################################################################
module "grafana" {
    source =  "../../../modules/aws-managed-grafana"
    region = var.region   
    grafana_version        = var.grafana_version
    workspace_api_keys_keyname = var.workspace_api_keys_keyname
    workspace_api_keys_keyrole = var.workspace_api_keys_keyrole
    workspace_api_keys_ttl = var.workspace_api_keys_ttl

}
############################################################################
## Prometheus
############################################################################
module "prometheus" {

  source          = "../../../modules/eks-monitoring"
  eks_cluster_id  = "${var.namespace}-${var.environment}-eks-cluster"
  grafana_url     = module.grafana.grafana_workspace_endpoint
  grafana_api_key = tostring(module.grafana.granafa_workspace_api_key.viewer.key)

  depends_on = [module.grafana]
}