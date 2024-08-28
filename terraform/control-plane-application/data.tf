############################################################################
## account lookup
############################################################################
data "aws_caller_identity" "current" {}

############################################################################
## github data
############################################################################
data "aws_ssm_parameter" "github_token" {
  name = "/github_token"
}

data "aws_ssm_parameter" "github_user" {
  name = "/github_user"
}

data "aws_ssm_parameter" "github_repo" {
  name = "/github_saas_repo"
}

############################################################################
## EKS data
############################################################################
data "aws_eks_cluster" "EKScluster" {
  name = "${var.namespace}-${var.environment}-eks-cluster"
}

data "aws_eks_cluster_auth" "EKScluster" {
  name = "${var.namespace}-${var.environment}-eks-cluster"
}

############################################################################
## Terraform remote state
############################################################################

data "aws_ssm_parameter" "terraform_state_bucket" {
  name = "/${var.namespace}/${var.environment}/terraform-state-bucket"
}

data "terraform_remote_state" "cognito" {
  backend = "s3"

  config = {
    region = var.region
    key    = "cognito/terraform.tfstate"
    bucket = data.aws_ssm_parameter.terraform_state_bucket.value
  }

}

############################################################################
## SSM Parameter data
############################################################################
data "aws_ssm_parameter" "db_user" {
  name = "/${var.namespace}/${var.environment}/db_user"
}
data "aws_ssm_parameter" "db_password" {
  name = "/${var.namespace}/${var.environment}/db_password"
}
data "aws_ssm_parameter" "db_host" {
  name = "/${var.namespace}/${var.environment}/db_host"
}
data "aws_ssm_parameter" "db_port" {
  name = "/${var.namespace}/${var.environment}/db_port"
}
data "aws_ssm_parameter" "db_schema" {
  name       = "/${var.namespace}/${var.environment}/db_schema"
  depends_on = [module.jwt_ssm_parameters]
}

data "aws_ssm_parameter" "jwt_issuer" {
  name       = "/${var.namespace}/${var.environment}/jwt_issuer"
  depends_on = [module.jwt_ssm_parameters]
}

data "aws_ssm_parameter" "jwt_secret" {
  name       = "/${var.namespace}/${var.environment}/jwt_secret"
  depends_on = [module.jwt_ssm_parameters]
}

data "aws_ssm_parameter" "authenticationdbdatabase" {
  name = "/${var.namespace}/${var.environment}/authenticationdbdatabase"
}
data "aws_ssm_parameter" "auditdbdatabase" {
  name = "/${var.namespace}/${var.environment}/auditdbdatabase"
}

data "aws_ssm_parameter" "notificationdbdatabase" {
  name = "/${var.namespace}/${var.environment}/notificationdbdatabase"
}

data "aws_ssm_parameter" "subscriptiondbdatabase" {
  name = "/${var.namespace}/${var.environment}/subscriptiondbdatabase"
}

data "aws_ssm_parameter" "userdbdatabase" {
  name = "/${var.namespace}/${var.environment}/userdbdatabase"
}

data "aws_ssm_parameter" "tenantmgmtdbdatabase" {
  name = "/${var.namespace}/${var.environment}/tenantmgmtdbdatabase"
}

data "aws_ssm_parameter" "redis_host" {
  name = "/${var.namespace}/${var.environment}/redis_host"
}


data "aws_ssm_parameter" "redis_port" {
  name = "/${var.namespace}/${var.environment}/redis_port"
}

data "aws_ssm_parameter" "redis_password" {
  name = "/${var.namespace}/${var.environment}/redis-password"
}

data "aws_ssm_parameter" "redis_database" {
  name = "/${var.namespace}/${var.environment}/redis-database"
}

data "aws_ssm_parameter" "cognito_domain" {
  name = "/${var.namespace}/${var.environment}/cognito_domain"
}

data "aws_ssm_parameter" "cognito_id" {
  name = "/${var.namespace}/${var.environment}/cognito_id"
}

data "aws_ssm_parameter" "cognito_secret" {
  name = "/${var.namespace}/${var.environment}/cognito_secret"
}

data "aws_ssm_parameter" "opensearch_domain_endpoint" {
  name = "/${var.namespace}/${var.environment}/opensearch/domain_endpoint"
}

data "aws_ssm_parameter" "https_connection_user" {
  name = "/${var.namespace}/https_connection_user"
}

data "aws_ssm_parameter" "https_connection_password" {
  name = "/${var.namespace}/https_connection_password"
}
################################################################################
## iam policy data
################################################################################
data "aws_iam_policy_document" "ssm_policy" {

  statement {
    sid    = "SSMPolicy"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "ssm:DescribeParameters",
      "ssm:DeleteParameters",
      "events:PutEvents"
    ]
    resources = ["arn:aws:ssm:${var.region}:${local.sts_caller_arn}:parameter/${var.namespace}/*",
    "arn:aws:events:${var.region}:${local.sts_caller_arn}:event-bus/${var.namespace}-${var.environment}-DecouplingEventBus"]
  }
}

data "aws_iam_policy_document" "codebuild_policy" {

  statement {
    sid    = "CodebuildPolicy"
    effect = "Allow"
    actions = [
      "codebuild:*"
    ]
    resources = ["arn:aws:codebuild:${var.region}:${local.sts_caller_arn}:project/${var.namespace}-${var.environment}-standard-codebuild-project",
    "arn:aws:codebuild:${var.region}:${local.sts_caller_arn}:project/${var.namespace}-${var.environment}-premium-codebuild-project"]
  }
}