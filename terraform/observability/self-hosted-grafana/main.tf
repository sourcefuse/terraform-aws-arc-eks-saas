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
## IAM Roles
################################################################################
module "web_identity_iam_role" {
  source              = "../../../modules/iam-role"
  role_name           = "${var.namespace}-${var.environment}-web-identity-role"
  role_description    = "Web Identity IAM role"
  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  principals = {
    "Federated" : ["arn:aws:iam::${local.sts_caller_arn}:oidc-provider/${local.oidc_arn}"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.grafana_eks_policy.*.json)
  ]
  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${local.oidc_arn}:sub"
      values   = ["system:serviceaccount:${var.grafana_namespace}:${var.service_account_name}"]
    }
  ]
  policy_name        = "${var.namespace}-${var.environment}-web-identity-policy"
  policy_description = "Web Identity IAM policy"
  tags               = module.tags.tags
}

resource "aws_iam_role_policy_attachment" "prometheus_managed_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusFullAccess"
  role       = "${var.namespace}-${var.environment}-web-identity-role"
  depends_on = [module.web_identity_iam_role]
}

resource "aws_iam_role_policy_attachment" "worker_node_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "${var.namespace}-${var.environment}-eks-workers"
}
################################################################################
## prometheus
################################################################################
module "prometheus" {
  source         = "../../../modules/eks-monitoring"
  eks_cluster_id = "${var.namespace}-${var.environment}-eks-cluster"
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
## grafana
############################################################################
module "grafana_password" {
  source           = "../../../modules/random-password"
  length           = 16
  is_special       = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "grafana_ssm_parameters" {
  source = "../../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/grafana_password"
      value       = module.grafana_password.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Grafana Password"
    }
  ]
  tags = module.tags.tags

}

resource "helm_release" "grafana" {

  depends_on       = [module.prometheus]
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = var.grafana_namespace
  create_namespace = true
  version          = var.grafana_helm_release_version

  values = [<<VALUES
serviceAccount:
  name: ${var.service_account_name}
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.namespace}-${var.environment}-web-identity-role"
grafana.ini:
  auth:
    sigv4_auth_enabled: true
additionalDataSources:
  - name: prometheus-amp
    editable: true
    jsonData:
      sigV4Auth: true
      sigV4Region: ${var.region}
    type: prometheus
    isDefault: true
VALUES
  ]

  set {
    name  = "adminUser"
    value = var.grafana_admin_username
  }

  set {
    name  = "adminPassword"
    value = module.grafana_password.result
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = var.grafana_volume_size
  }

  set {
    name  = "service.type"
    value = var.grafana_service_type
  }

  set {
    name  = "rbac.namespaced"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name
  }

}