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
######################################################################
## Create Cognito User
######################################################################
module "cognito_password" {
  source      = "../modules/random-password"
  length      = 12
  is_special  = true
  min_upper   = 1
  min_numeric = 1

}

resource "aws_cognito_user" "cognito_user" {
  user_pool_id = module.aws_cognito_user_pool.id
  username     = var.user_name

  attributes = {
    email          = var.tenant_email
    email_verified = true
  }
  temporary_password = module.cognito_password.result

  depends_on = [module.aws_cognito_user_pool]
}

###############################################################################
## Tenant IAM Role
###############################################################################
module "tenant_iam_role" {
  source              = "../modules/iam-role"
  role_name           = "${var.namespace}-${var.environment}-${var.tenant}-iam-role"
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
      values   = ["system:serviceaccount:${local.kubernetes_ns}:${var.tenant}"]
    }
  ]
  policy_name        = "${var.namespace}-${var.environment}-${var.tenant}-iam-policy"
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
      name        = "/${var.namespace}/${var.environment}/${var.tenant}/jwt_issuer"
      value       = var.jwt_issuer
      type        = "SecureString"
      overwrite   = "true"
      description = "${var.tenant} JWT Issuer"
    },
    {
      name        = "/${var.namespace}/${var.environment}/${var.tenant}/jwt_secret"
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

data "template_file" "helm_values_template" {
  template = file("${path.module}/application-helm/values.yaml")
  vars = {
    NAMESPACE        = local.kubernetes_ns
    TENANT_NAME      = var.tenant_name
    TENANT_KEY       = var.tenant
    TENANT_EMAIL     = var.tenant_email
    TENANT_SECRET    = var.tenant_secret
    TENANT_ID        = var.tenant_id
    COGNITO_USER     = var.user_name
    COGNITO_USER_SUB = aws_cognito_user.cognito_user.sub

    TENANT_CLIENT_ID      = var.tenant_client_id
    TENANT_CLIENT_SECRET  = var.tenant_client_secret
    REGION                = var.region
    COGNITO_DOMAIN        = data.aws_ssm_parameter.cognito_domain.name
    COGNITO_ID            = data.aws_ssm_parameter.cognito_id.name
    COGNITO_SECRET        = data.aws_ssm_parameter.cognito_secret.name
    KARPENTER_ROLE        = var.karpenter_role
    EKS_CLUSTER_NAME      = var.cluster_name
    TENANT_HOST_NAME      = var.tenant_host_domain
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
    AUDIT_DATABASE        = data.aws_ssm_parameter.auditdbdatabase.name
    NOTIFICATION_DATABASE = data.aws_ssm_parameter.notificationdbdatabase.name
    SCHEDULER_DATABASE    = data.aws_ssm_parameter.schedulerdbdatabase.name
    USER_DATABASE         = data.aws_ssm_parameter.userdbdatabase.name
    VIDEO_DATABASE        = data.aws_ssm_parameter.videodbdatabase.name
    DOCKER_USERNAME       = data.aws_ssm_parameter.docker_username.value
    DOCKER_PASSWORD       = data.aws_ssm_parameter.docker_password.value
  }
}

resource "local_file" "helm_values" {
  filename = "${path.module}/out/${var.tenant}-values.yaml"
  content  = data.template_file.helm_values_template.rendered
}


resource "helm_release" "application_helm" {
  name             = "app-plane"
  chart            = "application-helm" #Local Path of helm chart
  namespace        = kubernetes_namespace.my_namespace.metadata.0.name
  create_namespace = true
  force_update     = true
  recreate_pods    = true
  values           = [data.template_file.helm_values_template.rendered]
  depends_on = [
    module.tenant_iam_role, module.aurora, module.redis, module.aws_cognito_user_pool
  ]
}

# output 
output "changeme_preexisting_file_content" {
  value = resource.local_file.helm_values.content
}