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

resource "kubectl_manifest" "grafana_gateway" {


  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: grafana
  namespace: grafana
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "grafana.${var.domain_name}"
YAML



  depends_on = [
    module.grafana,
    module.prometheus
  ]

}

resource "kubectl_manifest" "grafana_virtual_service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: grafana
  namespace: grafana
spec:
  hosts:
    - "grafana.${var.domain_name}"
  gateways:
    - grafana 
  http:
    - match:
        - uri:
            prefix: /
      route:
        - destination:
            host: "grafana"
            port:
              number: 80
YAML

  depends_on = [
    module.grafana,
    module.prometheus
  ]

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

module "observability_ssm_parameters" {
  source = "../../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/prometheus_workspace_id"
      value       = module.prometheus.managed_prometheus_workspace_id
      type        = "SecureString"
      overwrite   = "true"
      description = "Amazon Managed Prometheus Workspace ID"
    }
  ]
  tags = module.tags.tags
  depends_on = [module.prometheus]

}

#####################################################################################
## Kuberhealthy Addon
#####################################################################################
resource "helm_release" "kuberhealthy" {
  name             = "kuberhealthy"
  repository       = "https://kuberhealthy.github.io/kuberhealthy/helm-repos"
  chart            = "kuberhealthy"
  version          = "104"
  namespace        = "kuberhealthy" # Specify the namespace where you want to deploy
  create_namespace = true

  set {
    name  = "checkReaper.maxKHJobAge"
    value = "1h"
  }

  set {
    name  = "checkReaper.maxCheckPodAge"
    value = "24h"
  }

  set {
    name  = "checkReaper.maxCompletedPodCount"
    value = 2
  }

  dynamic "set" {
    for_each = local.helm_settings
    content {
      name  = set.key
      value = set.value
    }
  }


  set {
    name  = "deployment.replicas"
    value = 1
  }

  set {
    name  = "prometheus.enabled"
    value = true
  }

  set {
    name  = "prometheus.prometheusRule.enabled"
    value = false
  }

  set {
    name  = "promtheus.serviceMonitor.enabled"
    value = false
  }

  set {
    name  = "check.daemonset.enabled"
    value = false
  }

  set {
    name  = "check.daemonset.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "check.deployment.enabled"
    value = false
  }

  set {
    name  = "check.dnsInternal.enabled"
    value = true
  }

  set {
    name  = "check.dnsExternal.enabled"
    value = true
  }

  set {
    name  = "check.dnsExternal.extraEnvs.HOSTNAME"
    value = var.domain_name
  }

  set {
    name  = "check.podRestarts.enabled"
    value = false
  }

  set {
    name  = "check.podRestarts.allNamespaces"
    value = true
  }

  set {
    name  = "check.podStatus.enabled"
    value = false
  }

  depends_on = [module.prometheus, module.grafana]
}

resource "kubectl_manifest" "http_checker" {
  yaml_body = <<YAML
apiVersion: comcast.github.io/v1
kind: KuberhealthyCheck
metadata:
  name: http-check
  namespace: kuberhealthy
spec:
  runInterval: 5m
  timeout: 10m
  podSpec:
    containers:
      - name: main
        image: kuberhealthy/http-check:latest
        imagePullPolicy: IfNotPresent
        env:
          - name: CHECK_URL
            value: "https://${var.domain_name}/"
          - name: COUNT
            value: "5"
          - name: SECONDS
            value: "1"
          - name: REQUEST_TYPE
            value: "GET"
          - name: PASSING
            value: "80"
YAML


  depends_on = [module.prometheus, module.grafana, helm_release.kuberhealthy]

}