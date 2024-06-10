################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

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

resource "aws_iam_role_policy_attachment" "cloudwatch_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccessV2"
  role       = "${var.namespace}-${var.environment}-web-identity-role"
  depends_on = [module.web_identity_iam_role]
}
################################################################################
## prometheus
################################################################################
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
  service_account_role_arn = module.prometheus_service_account_role.arn
  eks_cluster_id           = "${var.namespace}-${var.environment}-eks-cluster"
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
    },
    {
      name        = "/${var.namespace}/${var.environment}/grafana_username"
      value       = var.grafana_admin_username
      type        = "SecureString"
      overwrite   = "true"
      description = "Grafana UserName"
    },
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

resource "null_resource" "apply_manifests" {
  depends_on = [helm_release.grafana]

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

  depends_on = [module.prometheus, helm_release.grafana]
}

###############################################################################
## Canary Infra Creation for Tenants Synthetic Monitoring
###############################################################################
module "canary_infra" {
  source      = "../../../modules/canary-infra"
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