#############################################################################
## Data Import
#############################################################################
data "aws_partition" "this" {}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "github_token" {
   name = "/github_token"
}

data "aws_ssm_parameter" "github_user" {
   name = "/github_user"
}

data "aws_ssm_parameter" "github_repo" {
   name = "/github_saas_repo"
}

data "aws_eks_cluster" "EKScluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "EKScluster" {
  name = var.cluster_name
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
  filter {
    name = "tag:Environment"

    values = ["${var.environment}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Type"

    values = ["private"]
  }
  filter {
    name = "tag:Environment"

    values = ["${var.environment}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Type"

    values = ["public"]
  }
  filter {
    name = "tag:Environment"

    values = ["${var.environment}"]
  }
}

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
      "ssm:DeleteParameters"
    ]
    resources = ["arn:aws:ssm:${var.region}:${local.sts_caller_arn}:parameter/${var.namespace}/${var.environment}/${var.tenant_tier}/*"]
  }
}

######################################################################################
## SSM Data
######################################################################################
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

data "aws_ssm_parameter" "cognito_user_pool_id" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_user_pool_id"
}

data "aws_ssm_parameter" "cognito_domain" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_domain"
}

data "aws_ssm_parameter" "cognito_id" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_id"
  depends_on = [module.cognito_ssm_parameters]
}

data "aws_ssm_parameter" "cognito_secret" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant_tier}/cognito_secret"
  depends_on = [module.cognito_ssm_parameters]
}

data "aws_ssm_parameter" "db_user" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_user"
}

data "aws_ssm_parameter" "db_password" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_password"
}

data "aws_ssm_parameter" "db_host" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_host"
}

data "aws_ssm_parameter" "db_port" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_port"
}

data "aws_ssm_parameter" "db_schema" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/db_schema"
}

data "aws_ssm_parameter" "redis_host" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/redis_host"
}

data "aws_ssm_parameter" "redis_port" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/redis_port"
}

data "aws_ssm_parameter" "redis_database" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/redis-database"
}

data "aws_ssm_parameter" "authenticationdbdatabase" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/authenticationdbdatabase"
}

data "aws_ssm_parameter" "featuredbdatabase" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/featuredbdatabase"
}

data "aws_ssm_parameter" "notificationdbdatabase" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/notificationdbdatabase"
}


data "aws_ssm_parameter" "videoconfrencingdbdatabase" {
  name = "/${var.namespace}/${var.environment}/${var.tenant_tier}/videoconfrencingdbdatabase"
}

data "aws_ssm_parameter" "jwt_issuer" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/jwt_issuer"
  depends_on = [module.jwt_ssm_parameters]
}

data "aws_ssm_parameter" "jwt_secret" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant_tier}/${var.tenant}/jwt_secret"
  depends_on = [module.jwt_ssm_parameters]
}

data "aws_ssm_parameter" "opensearch_domain" {
  name = "/${var.namespace}/${var.environment}/opensearch/domain_endpoint"
}

data "aws_ssm_parameter" "opensearch_username" {
  name = "/${var.namespace}/${var.environment}/opensearch/admin_username"
}

data "aws_ssm_parameter" "opensearch_password" {
  name = "/${var.namespace}/${var.environment}/opensearch/admin_password"
}

data "aws_ssm_parameter" "codebuild_role" {
  name = "/${var.namespace}/${var.environment}/codebuild_role"
}

# canary data 

data "aws_ssm_parameter" "canary_report_bucket" {
  name = "/${var.namespace}/${var.environment}/canary/report-bucket"
}

data "aws_ssm_parameter" "canary_security_group" {
  name = "/${var.namespace}/${var.environment}/canary/security-group"
}

data "aws_ssm_parameter" "canary_role" {
  name = "/${var.namespace}/${var.environment}/canary/role"
}