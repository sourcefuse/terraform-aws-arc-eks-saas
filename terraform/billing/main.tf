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
module "kubecost_iam_role" {
  source              = "../../modules/iam-role"
  role_name           = "${var.namespace}-${var.environment}-kubecost-role"
  role_description    = "Kubecost IAM role"
  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  principals = {
    "Federated" : ["arn:aws:iam::${local.sts_caller_arn}:oidc-provider/${local.oidc_arn}"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.kubecost_sa_policy.*.json)
  ]
  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${local.oidc_arn}:sub"
      values   = ["system:serviceaccount:kubecost:kubecost-cost-analyzer"]
    },
    {
      test     = "StringEquals"
      variable = "${local.oidc_arn}:aud"
      values   = ["sts.amazonaws.com"]
    }
  ]
  policy_name        = "${var.namespace}-${var.environment}-kubecost-policy"
  policy_description = "Kubecost IAM policy"
  tags               = module.tags.tags
}

resource "aws_iam_role_policy_attachment" "kubecost_role_attachment1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusQueryAccess"
  role       = "${var.namespace}-${var.environment}-kubecost-role"
  depends_on = [module.kubecost_iam_role]
}

resource "aws_iam_role_policy_attachment" "kubecost_role_attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"
  role       = "${var.namespace}-${var.environment}-kubecost-role"
  depends_on = [module.kubecost_iam_role]
}

######################################################################
## KubeCost
######################################################################
resource "helm_release" "kubecost" {

  name             = "kubecost"
  repository       = "https://kubecost.github.io/cost-analyzer"
  chart            = "cost-analyzer"
  version          = "1.104.4"
  namespace        = "kubecost"
  create_namespace = true

  set {
    name  = "global.prometheus.enabled"
    value = true
  }

 # set {
 #   name  = "global.prometheus.fqdn"
 #   value = ""
#  }

  set {
    name  = "global.grafana.enabled"
    value = true
  }

 # set {
  #  name  = "global.grafana.domainName"
  #  value = ""
 # }

  set {
    name  = "global.amp.enabled"
    value = false
  }

  set {
    name  = "global.amp.prometheusServerEndpoint"
    value = "http://localhost:8005/workspaces/${data.aws_ssm_parameter.prometheus_workspace_id.value}"
  }

  set {
    name  = "global.amp.remoteWriteService"
    value = "https://aps-workspaces.${var.region}.amazonaws.com/workspaces/${data.aws_ssm_parameter.prometheus_workspace_id.value}/api/v1/remote_write"
  }

  set {
    name  = "global.amp.sigv4.region"
    value = var.region
  }

  set {
    name  = "global.savedReports.enabled"
    value = true
  }

  set {
    name  = "global.cloudCostReports.enabled"
    value = true
  }

  set {
    name  = "upgrade.toV2"
    value = true
  }

  set {
    name  = "sigV4Proxy.region"
    value = var.region
  }

  set {
    name  = "sigV4Proxy.host"
    value = "aps-workspaces.${var.region}.amazonaws.com"
  }

  set {
    name  = "networkCosts.enabled"
    value = true
  }

  set {
    name  = "kubecostFrontend.enabled"
    value = true
  }

}

resource "kubernetes_annotations" "service_account" {
  api_version = "v1"
  kind        = "ServiceAccount"
  metadata {
    name      = "kubecost-cost-analyzer"
    namespace = "kubecost"
  }

  annotations = {
    "eks.amazonaws.com/role-arn" = "${module.kubecost_iam_role.arn}"
  }

  depends_on = [module.kubecost_iam_role, helm_release.kubecost]
}
