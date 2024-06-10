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
data "template_file" "kubecost_helm_value_template" {
  template = file("${path.module}/values-amp.yaml")
  vars = {
    REGION           = var.region
    WORKSPACE_ID     = data.aws_ssm_parameter.prometheus_workspace_id.value
    EKS_CLUSTER_NAME = "${var.namespace}-${var.environment}-eks-cluster"
  }
}

resource "local_file" "helm_values" {
  filename = "${path.module}/out/values-amp.yaml"
  content  = data.template_file.kubecost_helm_value_template.rendered
}

resource "helm_release" "kubecost" {

  name             = "kubecost"
  repository       = "https://kubecost.github.io/cost-analyzer"
  chart            = "cost-analyzer"
  version          = "2.1.1"
  namespace        = "kubecost"
  create_namespace = true

  values = [data.template_file.kubecost_helm_value_template.rendered]


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

###############################################################################
## Kubecost Ingress
###############################################################################
data "template_file" "ingress_template" {
  template = file("${path.module}/../../files/control-plane/kubecost-helm/values.yaml.template")
  vars = {
    DOMAIN = var.domain_name
  }
}

resource "helm_release" "kubecost_ingress" {
  name             = "kubecost-ingress"
  chart            = "../../files/control-plane/kubecost-helm"
  namespace        = "kubecost"
  create_namespace = false
  force_update     = true
  values           = [data.template_file.ingress_template.rendered]
  depends_on       = [helm_release.kubecost]

}

#################################################################################
## Billing alerts
#################################################################################
module "budgets" {
  source  = "sourcefuse/arc-billing/aws"
  version = "0.0.1"

  namespace   = var.namespace
  environment = var.environment

  budgets = var.budgets

  notifications_enabled = var.notifications_enabled
  encryption_enabled    = var.encryption_enabled

  slack_webhook_url = var.slack_webhook_url
  slack_channel     = var.slack_channel
  slack_username    = var.slack_username

  billing_alerts_sns_subscribers = var.billing_alerts_sns_subscribers

  tags = module.tags.tags
}
