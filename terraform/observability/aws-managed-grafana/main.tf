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

resource "null_resource" "apply_manifests" {
  depends_on = [module.grafana]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/grafana-manifest-files/grafana_gateway.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/grafana-manifest-files/grafana_virtual_service.yaml"
  }
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
  tags       = module.tags.tags
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

###############################################################################
## Canary Infra Creation for Tenants Synthetic Monitoring
###############################################################################
module "canary_infra" {
  source      = "../../..modules/canary-infra"
  namespace   = var.namespace
  environment = var.environment
  vpc_id      = data.aws_vpc.vpc.id
  subnet_ids  = data.aws_subnets.private.ids
  tags        = module.tags.tags
}


module "canary_ssm_parameters" {
  source = "../../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/canary/report-bucket"
      value       = module.canary_infra.reports-bucket
      type        = "String"
      overwrite   = "true"
      description = "Canary S3 Report Bukcet"
    },
    {
      name        = "/${var.namespace}/${var.environment}/canary/security-group"
      value       = module.canary_infra.security_group_id
      type        = "SecureString"
      overwrite   = "true"
      description = "Canary Security Group ID"
    },
    {
      name        = "/${var.namespace}/${var.environment}/canary/role"
      value       = module.canary_infra.role
      type        = "SecureString"
      overwrite   = "true"
      description = "Canary IAM Role"
    }
  ]
  tags = module.tags.tags
}