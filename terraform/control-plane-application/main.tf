################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

  }

  backend "s3" {}
}

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
################################################################################
## tag
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}


################################################################################
## Control Plane Role
################################################################################
module "control_plane_iam_role" {
  source              = "../../modules/iam-role"
  role_name           = "${var.namespace}-${var.environment}-control-plane-role"
  role_description    = "IAM role for control plane application"
  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  principals = {
    "Federated" : ["arn:aws:iam::${local.sts_caller_arn}:oidc-provider/${local.oidc_arn}"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.ssm_policy.*.json),
    join("", data.aws_iam_policy_document.codebuild_policy.*.json)
  ]
  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${local.oidc_arn}:sub"
      values   = ["system:serviceaccount:${local.kubernetes_ns}:control-plane"]
    }
  ]
  policy_name        = "${var.namespace}-${var.environment}-control-plane-policy"
  policy_description = "IAM policy for control plane application"
  tags               = module.tags.tags
}

################################################################################
## Store JWT secrets and issuer in parameter store
################################################################################
module "jwt_secret" {
  source     = "../../modules/random-password"
  length     = 16
  is_special = false
}

module "jwt_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/jwt_issuer"
      value       = var.jwt_issuer
      type        = "SecureString"
      overwrite   = "true"
      description = "JWT Issuer"
    },
    {
      name        = "/${var.namespace}/${var.environment}/jwt_secret"
      value       = module.jwt_secret.result
      type        = "SecureString"
      overwrite   = "true"
      description = "JWT Secret"
    },
    {
      name        = "/${var.namespace}/${var.environment}/db_schema"
      value       = "main"
      type        = "SecureString"
      overwrite   = "true"
      description = "DB Schema"
    }
  ]
  tags = module.tags.tags
}
################################################################################
## Create Congito User
################################################################################
module "cognito_password" {
  source      = "../../modules/random-password"
  length      = 12
  is_special  = true
  min_upper   = 1
  min_numeric = 1

}

resource "aws_cognito_user" "cognito_user" {
  user_pool_id = data.terraform_remote_state.cognito.outputs.id
  username     = var.user_name

  attributes = {
    email          = var.tenant_email
    email_verified = true
  }
  temporary_password = module.cognito_password.result
}


################################################################################
## Control Plane
################################################################################
resource "kubernetes_namespace" "my_namespace" {
  metadata {
    name = local.kubernetes_ns

    labels = {
      istio-injection = "enabled"
    }
  }

  lifecycle {
    prevent_destroy = false # Allows Terraform to delete the namespace
  }
}

data "template_file" "fluentbit_helm_value_template" {
  template = file("${path.module}/../../files/control-plane/fluent-bit-helm/values.yaml.template")
  vars = {
    REGION             = var.region
    OS_DOMAIN_ENDPOINT = data.aws_ssm_parameter.opensearch_domain_endpoint.value
  }
}

data "template_file" "helm_values_template" {
  template = file("${path.module}/../../files/control-plane/control-plane-helm-chart/values.yaml.template")
  vars = {
    NAMESPACE                 = local.kubernetes_ns
    namespace                 = var.namespace
    TENANT_NAME               = var.tenant_name
    TENANT_EMAIL              = var.tenant_email
    COGNITO_USER              = var.user_name
    COGNITO_USER_SUB          = aws_cognito_user.cognito_user.sub
    SILO_PIPELINE             = "${var.namespace}-${var.environment}-premium-codebuild-project"
    POOLED_PIPELINE           = "${var.namespace}-${var.environment}-standard-codebuild-project"
    REGION                    = var.region
    CONTROL_PLANE_HOST_DOMAIN = var.domain_name
    DOMAIN                    = var.domain_name
    WEB_IDENTITY_ROLE_ARN     = module.control_plane_iam_role.arn
    DB_HOST                   = data.aws_ssm_parameter.db_host.name
    DB_PORT                   = data.aws_ssm_parameter.db_port.name
    DB_USER                   = data.aws_ssm_parameter.db_user.name
    DB_PASSWORD               = data.aws_ssm_parameter.db_password.name
    DB_SCHEMA                 = data.aws_ssm_parameter.db_schema.name
    REDIS_HOST                = data.aws_ssm_parameter.redis_host.name
    REDIS_PORT                = data.aws_ssm_parameter.redis_port.name
    REDIS_PASSWORD            = data.aws_ssm_parameter.redis_password.name
    REDIS_DATABASE            = data.aws_ssm_parameter.redis_database.name
    JWT_SECRET                = data.aws_ssm_parameter.jwt_secret.name
    JWT_ISSUER                = data.aws_ssm_parameter.jwt_issuer.name
    AUTH_DATABASE             = data.aws_ssm_parameter.authenticationdbdatabase.name
    AUDIT_DATABASE            = data.aws_ssm_parameter.auditdbdatabase.name
    NOTIFICATION_DATABASE     = data.aws_ssm_parameter.notificationdbdatabase.name
    SUBSCRIPTION_DATABASE     = data.aws_ssm_parameter.subscriptiondbdatabase.name
    USER_DATABASE             = data.aws_ssm_parameter.userdbdatabase.name
    TENANT_MGMT_DATABASE      = data.aws_ssm_parameter.tenantmgmtdbdatabase.name
    COGNITO_DOMAIN            = data.aws_ssm_parameter.cognito_domain.name
    COGNITO_ID                = data.aws_ssm_parameter.cognito_id.name
    COGNITO_SECRET            = data.aws_ssm_parameter.cognito_secret.name
    FROM_EMAIL                = var.from_email
  }
}

resource "local_file" "helm_values" {
  filename = "${path.module}/output/control-plane-values.yaml"
  content  = data.template_file.helm_values_template.rendered
}

# Helm chart deployment
# resource "helm_release" "control_plane_app" {
#   name             = "control-plane"
#   chart            = "../../files/control-plane/control-plane-helm-chart" #Local Path of helm chart
#   namespace        = kubernetes_namespace.my_namespace.metadata.0.name
#   create_namespace = true
#   force_update     = true
#   recreate_pods    = true
#   values           = [data.template_file.helm_values_template.rendered]
#   depends_on = [
#     module.control_plane_iam_role
#   ]
# }

resource "helm_release" "fluent_bit" {
  count            = 1
  name             = "aws-for-fluent-bits"
  chart            = "../../files/control-plane/fluent-bit-helm"
  namespace        = "kube-system"
  create_namespace = false
  force_update     = true
  replace          = true
  values           = [data.template_file.fluentbit_helm_value_template.rendered]
}

##################################################################################
## Create ARGOCD Repository Secret to connect tenant gitops repository 
##################################################################################
# Connect using SSH please follow this https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-repositories-yaml/
# argocd
resource "kubectl_manifest" "argocd_repo_secret" {
  yaml_body = <<YAML
  apiVersion: v1
  kind: Secret
  metadata:
    name: tenant-helm-repo
    namespace: argocd
    labels:
      argocd.argoproj.io/secret-type: repository
  stringData:
    url: https://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.namespace}-${var.environment}-tenant-management-gitops-repository
    password: ${data.aws_ssm_parameter.https_connection_password.value}
    username: ${data.aws_ssm_parameter.https_connection_user.value}
    insecure: "true" # Ignore validity of server's TLS certificate. Defaults to "false"
    forceHttpBasicAuth: "true" # Skip auth method negotiation and force usage of HTTP basic auth. Defaults to "false"
    enableLfs: "true"
YAML
}

#argo-workflow
resource "kubectl_manifest" "argo_workflow_repo_secret" {
  yaml_body = <<YAML
  apiVersion: v1
  kind: Secret
  metadata:
    name: codecommit-secret
    namespace: argo-workflows
    labels:
      argocd.argoproj.io/secret-type: repository
  stringData:
    url: https://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.namespace}-${var.environment}-tenant-management-gitops-repository
    password: ${data.aws_ssm_parameter.https_connection_password.value}
    username: ${data.aws_ssm_parameter.https_connection_user.value}
    insecure: "true" # Ignore validity of server's TLS certificate. Defaults to "false"
    forceHttpBasicAuth: "true" # Skip auth method negotiation and force usage of HTTP basic auth. Defaults to "false"
    enableLfs: "true"
YAML
}

###############################################################################################
## Register control plane Helm App on ArgoCD
###############################################################################################
resource "local_file" "argocd_application" {
  content  = <<-EOT
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: control-plane-app
  namespace: argocd
  labels:
    project: ${var.namespace}
    name: control-plane
    environment: ${var.environment}
spec:
  destination:
    namespace: ${local.kubernetes_ns}
    server: 'https://kubernetes.default.svc'
  source:
    path: control-plane
    repoURL: 'https://git-codecommit.${var.region}.amazonaws.com/v1/repos/${var.namespace}-${var.environment}-tenant-management-gitops-repository'
    targetRevision: main
    helm:
      valueFiles:
        - control-plane-values.yaml
  project: default  
  syncPolicy:
    syncOptions:
      - ApplyOutOfSyncOnly=true
    retry:
      limit: 2
      backoff:
        duration: 5s
        maxDuration: 3m0s
        factor: 2
    automated:
      prune: false
      selfHeal: true
    EOT
  filename = "${path.module}/control-plane-argocd-application.yaml"
}