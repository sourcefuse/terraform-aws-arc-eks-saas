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
  source                     = "../../../modules/aws-managed-grafana"
  region                     = var.region
  grafana_version            = var.grafana_version
  workspace_api_keys_keyname = var.workspace_api_keys_keyname
  workspace_api_keys_keyrole = var.workspace_api_keys_keyrole
  workspace_api_keys_ttl     = var.workspace_api_keys_ttl

}
############################################################################
## Prometheus
############################################################################
module "prometheus_service_account_role" {
  source              = "../../../modules/iam-role"
  role_name           = "${var.namespace}-${var.environment}-prometheus-service-account-role"
  role_description    = "Service Account Role for prometheus"
  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  principals = {
    "Federated" : ["arn:aws:iam::${local.sts_caller_arn}:oidc-provider/${local.oidc_arn}"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.prometheus_sa_policy.*.json)
  ]
  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${local.oidc_arn}:sub"
      values   = ["system:serviceaccount:prometheus-node-exporter:prometheus-node-exporter"]
    }
  ]
  policy_name        = "${var.namespace}-${var.environment}-prometheus-service-account-policy"
  policy_description = "Service Account Policy for prometheus"
  tags               = module.tags.tags
}

module "prometheus" {

  source                   = "../../../modules/eks-monitoring"
  eks_cluster_id           = "${var.namespace}-${var.environment}-eks-cluster"
  grafana_url              = module.grafana.grafana_workspace_endpoint
  grafana_api_key          = tostring(module.grafana.granafa_workspace_api_key.viewer.key)
  service_account_role_arn = module.prometheus_service_account_role.arn

  depends_on = [module.grafana]
}