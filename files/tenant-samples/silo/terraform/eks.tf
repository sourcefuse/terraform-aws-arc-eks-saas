################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Tenant    = var.tenant
    Tenant_ID = var.tenant_id
    Tier = var.tenant_tier
  }

}

###############################################################################
## Register domain name in Route53
###############################################################################
module "route53-record" {
  source  = "clouddrove/route53-record/aws"
  version = "1.0.1"
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.tenant}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "60"
  values  = var.alb_url
}


###############################################################################
## Tenant IAM Role
###############################################################################
module "tenant_iam_role" {
  source              = "../modules/iam-role"
  role_name           = "${var.namespace}-${var.environment}-${var.tenant_tier}-${var.tenant}-iam-role"
  role_description    = "IAM role for ${var.tenant} application"
  assume_role_actions = ["sts:AssumeRoleWithWebIdentity"]
  principals = {
    "Federated" : ["arn:aws:iam::${local.sts_caller_arn}:oidc-provider/${local.oidc_arn}"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.ssm_policy.*.json)
  ]
  assume_role_conditions = [
    {
      test     = "StringEquals"
      variable = "${local.oidc_arn}:sub"
      values   = ["system:serviceaccount:${local.kubernetes_ns}:${var.tenant_tier}-${var.tenant}"]
    }
  ]
  policy_name        = "${var.namespace}-${var.environment}-${var.tenant_tier}-${var.tenant}-iam-policy"
  policy_description = "IAM policy for ${var.tenant} application"
  tags               = module.tags.tags
}

################################################################################
## Store JWT secrets and issuer in parameter store
################################################################################
module "jwt_secret" {
  source     = "../modules/random-password"
  length     = 16
  is_special = false
}

module "jwt_ssm_parameters" {
  source = "../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/jwt_issuer"
      value       = var.jwt_issuer
      type        = "SecureString"
      overwrite   = "true"
      description = "${var.tenant} JWT Issuer"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/jwt_secret"
      value       = module.jwt_secret.result
      type        = "SecureString"
      overwrite   = "true"
      description = "${var.tenant} JWT Secret"
    }
  ]
  tags = module.tags.tags
}

################################################################################
## Application Helm
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

# generate tenant specific helm values.yaml file

data "template_file" "helm_values_template" {
  template = file("${path.module}/../tenant-helm-chart/values.yaml.template")
  vars = {
    NAMESPACE        = local.kubernetes_ns
    TENANT_NAME      = var.tenant_name
    TENANT_KEY       = var.tenant
    TENANT_EMAIL     = var.tenant_email
    TENANT_SECRET    = var.tenant_secret
    TENANT_ID        = var.tenant_id
    COGNITO_USER     = var.user_name
    COGNITO_USER_SUB = aws_cognito_user.cognito_user.sub

    TIER = var.tenant_tier
    TENANT_CLIENT_ID      = var.tenant_client_id
    TENANT_CLIENT_SECRET  = var.tenant_client_secret
    REGION                = var.region
    COGNITO_DOMAIN        = data.aws_ssm_parameter.cognito_domain.name
    COGNITO_ID            = data.aws_ssm_parameter.cognito_id.name
    COGNITO_SECRET        = data.aws_ssm_parameter.cognito_secret.name
    KARPENTER_ROLE        = var.karpenter_role
    EKS_CLUSTER_NAME      = var.cluster_name
    TENANT_HOST_NAME      = var.tenant_host_domain
    USER_CALLBACK_SECRET  = var.user_callback_secret
    WEB_IDENTITY_ROLE_ARN = module.tenant_iam_role.arn
    DB_HOST               = data.aws_ssm_parameter.db_host.name
    DB_PORT               = data.aws_ssm_parameter.db_port.name
    DB_USER               = data.aws_ssm_parameter.db_user.name
    DB_PASSWORD           = data.aws_ssm_parameter.db_password.name
    DB_SCHEMA             = data.aws_ssm_parameter.db_schema.name
    REDIS_HOST            = data.aws_ssm_parameter.redis_host.name
    REDIS_PORT            = data.aws_ssm_parameter.redis_port.name
    REDIS_DATABASE        = data.aws_ssm_parameter.redis_database.name
    JWT_SECRET            = data.aws_ssm_parameter.jwt_secret.name
    JWT_ISSUER            = data.aws_ssm_parameter.jwt_issuer.name
    AUTH_DATABASE         = data.aws_ssm_parameter.authenticationdbdatabase.name
    FEATURE_DATABASE        = data.aws_ssm_parameter.featuredbdatabase.name
    NOTIFICATION_DATABASE = data.aws_ssm_parameter.notificationdbdatabase.name
    VIDEO_CONFRENCING_DATABASE      = data.aws_ssm_parameter.videoconfrencingdbdatabase.name
    INSTANCE_CATEGORY     = var.karpenter_instance_category
  }
}


resource "local_file" "helm_values" {
  filename = "${path.module}/output/${var.tenant}-values.yaml"
  content  = data.template_file.helm_values_template.rendered
}

###############################################################################################
## Register Tenant Helm App on ArgoCD
###############################################################################################
resource "local_file" "argocd_application" {
  content  = <<-EOT
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: ${var.tenant_tier}-${var.tenant}
  namespace: argocd
  labels:
    Tenant: ${var.tenant} 
    Tenant_ID: ${var.tenant_id}
spec:
  destination:
    namespace: ${var.tenant_tier}-${var.tenant}
    server: 'https://kubernetes.default.svc'
  source:
    path: onboarded-tenants/silo/application
    repoURL: 'https://${data.aws_ssm_parameter.github_user.value}@github.com/${data.aws_ssm_parameter.github_repo.value}.git'
    targetRevision: main
    helm:
      valueFiles:
        - ${var.tenant}-values.yaml
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
  filename = "${path.module}/argocd-application.yaml"
}

#######################################################################################
## Register Tenant Terraform Workflow on Argo
#######################################################################################
resource "local_file" "argo_workflow" {
  content  = <<-EOT
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  name: ${var.tenant_tier}-${var.tenant}-terraform-workflow
  namespace: argo-workflows
spec:
  entrypoint: terraform-apply
  templates:
    - name: terraform-apply
      inputs:
        artifacts:
          - name: terraform
            path: /home/terraform
            git:
              repo: https://${data.aws_ssm_parameter.github_user.value}@github.com/${data.aws_ssm_parameter.github_repo.value}.git
              depth: 1
              usernameSecret:
                name: github-secret
                key: username
              passwordSecret:
                name: github-secret
                key: password
      container:
        imagePullPolicy: "Always"
        image: public.ecr.aws/f6f1e4v9/terraform:argo-terraform
        command:
          - sh
          - -c
        args:
          - |
            export KUBECONFIG=$HOME/.kube/config
            CREDENTIALS=$(aws sts assume-role --role-arn ${data.aws_ssm_parameter.codebuild_role.value} --role-session-name codebuild-kubectl --duration-seconds 3600)
            export AWS_ACCESS_KEY_ID=$(echo "$CREDENTIALS" | jq -r '.Credentials.AccessKeyId')
            export AWS_SECRET_ACCESS_KEY=$(echo "$CREDENTIALS" | jq -r '.Credentials.SecretAccessKey')
            export AWS_SESSION_TOKEN=$(echo "$CREDENTIALS" | jq -r '.Credentials.SessionToken')
            export AWS_EXPIRATION=$(echo "$CREDENTIALS" | jq -r '.Credentials.Expiration')
            aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}
            cp -r /home/terraform/onboarded-tenants/silo/infra/* /home/myuser/
            cd terraform
            /bin/terraform init --backend-config=config.${var.tenant}.hcl
            /bin/terraform plan --var-file=${var.tenant}.tfvars --refresh=false
            /bin/terraform apply --var-file=${var.tenant}.tfvars --auto-approve
    EOT
  filename = "${path.module}/argo-workflow.yaml"
}

