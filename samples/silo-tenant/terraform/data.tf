#############################################################################
## Data Import
#############################################################################
data "aws_partition" "this" {}

data "aws_caller_identity" "current" {}

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
}

data "aws_subnets" "private" {
  filter {
    name = "tag:Type"

    values = ["private"]
  }
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Type"

    values = ["public"]
  }
}

data "aws_security_groups" "aurora" {
  depends_on = [module.aurora]
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-${var.tenant}-aurora"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
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
    resources = ["arn:aws:ssm:${var.region}:${local.sts_caller_arn}:parameter/${var.namespace}/${var.environment}/${var.tenant}/*"]
  }
}

######################################################################################
## SSM Data
######################################################################################
data "aws_ssm_parameter" "docker_username" {
  name = "/${var.namespace}/${var.environment}/docker_username"
}
data "aws_ssm_parameter" "docker_password" {
  name = "/${var.namespace}/${var.environment}/docker_password"
}

data "aws_ssm_parameter" "cognito_domain" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/cognito_domain"
  depends_on = [module.cognito_ssm_parameters]
}

data "aws_ssm_parameter" "cognito_id" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/cognito_id"
  depends_on = [module.cognito_ssm_parameters]
}

data "aws_ssm_parameter" "cognito_secret" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/cognito_secret"
  depends_on = [module.cognito_ssm_parameters]
}

data "aws_ssm_parameter" "db_user" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/db_user"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "db_password" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/db_password"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "db_host" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/db_host"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "db_port" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/db_port"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "db_schema" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/db_schema"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "redis_host" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/redis_host"
  depends_on = [module.redis_ssm_parameters]
}

data "aws_ssm_parameter" "redis_port" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/redis_port"
  depends_on = [module.redis_ssm_parameters]
}

data "aws_ssm_parameter" "redis_database" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/redis-database"
  depends_on = [module.redis_ssm_parameters]
}

data "aws_ssm_parameter" "authenticationdbdatabase" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/authenticationdbdatabase"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "auditdbdatabase" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/auditdbdatabase"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "notificationdbdatabase" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/notificationdbdatabase"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "schedulerdbdatabase" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/schedulerdbdatabase"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "userdbdatabase" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/userdbdatabase"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "videodbdatabase" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/videodbdatabase"
  depends_on = [module.db_ssm_parameters]
}

data "aws_ssm_parameter" "jwt_issuer" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/jwt_issuer"
  depends_on = [module.jwt_ssm_parameters]
}

data "aws_ssm_parameter" "jwt_secret" {
  name       = "/${var.namespace}/${var.environment}/${var.tenant}/jwt_secret"
  depends_on = [module.jwt_ssm_parameters]
}