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
## Tenant Codebuild Role
################################################################################
module "tenant_codebuild_iam_role" {
  source           = "../../modules/iam-role"
  role_name        = "${var.namespace}-${var.environment}-tenant-codebuild-role"
  role_description = "IAM role for tenant codebuild projects"
  principals = {
    "Service" : ["codebuild.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.tenant_codebuild_policy.*.json),
    join("", data.aws_iam_policy_document.assume_role_policy.*.json)
  ]
  policy_name        = "${var.namespace}-${var.environment}-tenant-codebuild-policy"
  policy_description = "IAM policy for tenant codebuild projects"
  tags               = module.tags.tags
}
################################################################################
## Generate tenant client id & secret and store in SSM
################################################################################
module "silo_tenant_client_id" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}

module "silo_tenant_client_secret" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}

module "pooled_tenant_client_id" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}

module "pooled_tenant_client_secret" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}

module "tenant_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/silo/tenant_client_id"
      value       = module.silo_tenant_client_id.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Client ID for silo application plane"
    },
    {
      name        = "/${var.namespace}/${var.environment}/silo/tenant_client_secret"
      value       = module.silo_tenant_client_secret.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Client Secret for silo application plane"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/tenant_client_id"
      value       = module.pooled_tenant_client_id.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Client ID for pooled application plane"
    },
    {
      name        = "/${var.namespace}/${var.environment}/pooled/tenant_client_secret"
      value       = module.pooled_tenant_client_secret.result
      type        = "SecureString"
      overwrite   = "true"
      description = "Tenant Client Secret for pooled application plane"
    }
  ]
  tags = module.tags.tags
}
################################################################################
## Codebuild Projects
################################################################################
module "premium_plan_codebuild_project" {
  count       = var.create_premium_codebuild ? 1 : 0
  source      = "../../modules/codebuild"
  name        = "${var.namespace}-${var.environment}-premium-codebuild-project"
  description = "Premium plan codebuild project"

  concurrent_build_limit = var.concurrent_build_limit
  service_role           = module.tenant_codebuild_iam_role.arn
  build_timeout          = var.build_timeout
  queued_timeout         = var.queued_timeout

  source_version  = var.premium_source_version
  source_type     = var.source_type
  buildspec       = var.premium_buildspec
  source_location = aws_codecommit_repository.premium_repo.clone_url_http

  vpc_id             = data.aws_vpc.vpc.id
  subnets            = data.aws_subnets.private.ids
  security_group_ids = [data.aws_security_groups.codebuild_db_access.ids[0]]

  build_compute_type                = var.build_compute_type
  build_image                       = var.build_image
  build_type                        = var.build_type
  build_image_pull_credentials_type = var.build_image_pull_credentials_type
  privileged_mode                   = var.privileged_mode

  environment_variables = [
    {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.this.account_id
      type  = "PLAINTEXT"
    },
    {
      name  = "AWS_REGION"
      value = var.region
      type  = "PLAINTEXT"
    },
    {
      name  = "NAMESPACE"
      value = var.namespace
      type  = "PLAINTEXT"
    },
    {
      name  = "ENVIRONMENT"
      value = var.environment
      type  = "PLAINTEXT"
    },
    {
      name  = "VPC_ID"
      value = data.aws_vpc.vpc.id
      type  = "PLAINTEXT"
    },
    {
      name  = "VPC_CIDR_BLOCK"
      value = data.aws_vpc.vpc.cidr_block
      type  = "PLAINTEXT"
    },
    {
      name  = "SUBNET_IDS"
      value = join(",", data.aws_subnets.private.ids)
      type  = "PLAINTEXT"
    },
    {
      name  = "EKS_CLUSTER_NAME"
      value = "${var.namespace}-${var.environment}-eks-cluster"
      type  = "PLAINTEXT"
    },
    {
      name  = "CB_ROLE"
      value = data.aws_ssm_parameter.codebuild_role.value
      type  = "PLAINTEXT"
    },
    {
      name  = "KARPENTER_ROLE"
      value = data.aws_ssm_parameter.karpenter_role.value
      type  = "PLAINTEXT"
    },
    {
      name  = "DOMAIN_NAME"
      value = var.domain_name
      type  = "PLAINTEXT"
    },
    {
      name  = "CONTROL_PLANE_HOST"
      value = var.control_plane_host
      type  = "PLAINTEXT"
    },
    {
      name  = "USERNAME"
      value = "test"
      type  = "PLAINTEXT"
    },
    {
      name  = "ACCESS_TOKEN_EXPIRATION"
      value = 3600
      type  = "PLAINTEXT"
    },
    {
      name  = "REFRESH_TOKEN_EXPIRATION"
      value = 3600
      type  = "PLAINTEXT"
    },
    {
      name  = "AUTH_CODE_EXPIRATION"
      value = 3600
      type  = "PLAINTEXT"
    },
    {
      name  = "TENANT_CLIENT_ID"
      value = "/${var.namespace}/${var.environment}/silo/tenant_client_id"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "TENANT_CLIENT_SECRET"
      value = "/${var.namespace}/${var.environment}/silo/tenant_client_secret"
      type  = "PARAMETER_STORE"
    }
  ]

  cloudwatch_log_group_name  = var.premium_cloudwatch_log_group_name
  cloudwatch_log_stream_name = var.cloudwatch_log_stream_name

  enable_codebuild_authentication = false
  # source_credential_auth_type     = "PERSONAL_ACCESS_TOKEN"
  # source_credential_server_type   = "GITHUB"
  # source_credential_token         = data.aws_ssm_parameter.github_token.value

  tags       = module.tags.tags
  depends_on = [module.tenant_ssm_parameters, aws_codecommit_repository.premium_repo]
}

resource "aws_codecommit_repository" "premium_repo" {
  repository_name = "${var.namespace}-${var.environment}-premium-plan-repository"
  description     = "${var.namespace}-${var.environment}-premium-repository."
  default_branch  = "main"

  lifecycle {
    prevent_destroy = true
  }
}

# standard
module "standard_plan_codebuild_project" {
  count       = var.create_standard_codebuild ? 1 : 0
  source      = "../../modules/codebuild"
  name        = "${var.namespace}-${var.environment}-standard-codebuild-project"
  description = "Standard plan codebuild project"

  concurrent_build_limit = var.concurrent_build_limit
  service_role           = module.tenant_codebuild_iam_role.arn
  build_timeout          = var.build_timeout
  queued_timeout         = var.queued_timeout

  source_version  = var.standard_source_version
  source_type     = var.source_type
  buildspec       = var.standard_buildspec
  source_location = aws_codecommit_repository.standard_repo.clone_url_http

  vpc_id             = data.aws_vpc.vpc.id
  subnets            = data.aws_subnets.private.ids
  security_group_ids = [data.aws_security_groups.codebuild_db_access.ids[0]]

  build_compute_type                = var.build_compute_type
  build_image                       = var.build_image
  build_type                        = var.build_type
  build_image_pull_credentials_type = var.build_image_pull_credentials_type
  privileged_mode                   = var.privileged_mode

  environment_variables = [
    {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.this.account_id
      type  = "PLAINTEXT"
    },
    {
      name  = "AWS_REGION"
      value = var.region
      type  = "PLAINTEXT"
    },
    {
      name  = "NAMESPACE"
      value = var.namespace
      type  = "PLAINTEXT"
    },
    {
      name  = "ENVIRONMENT"
      value = var.environment
      type  = "PLAINTEXT"
    },
    {
      name  = "VPC_ID"
      value = data.aws_vpc.vpc.id
      type  = "PLAINTEXT"
    },
    {
      name  = "VPC_CIDR_BLOCK"
      value = data.aws_vpc.vpc.cidr_block
      type  = "PLAINTEXT"
    },
    {
      name  = "SUBNET_IDS"
      value = join(",", data.aws_subnets.private.ids)
      type  = "PLAINTEXT"
    },
    {
      name  = "EKS_CLUSTER_NAME"
      value = "${var.namespace}-${var.environment}-eks-cluster"
      type  = "PLAINTEXT"
    },
    {
      name  = "CB_ROLE"
      value = data.aws_ssm_parameter.codebuild_role.value
      type  = "PLAINTEXT"
    },
    {
      name  = "KARPENTER_ROLE"
      value = data.aws_ssm_parameter.karpenter_role.value
      type  = "PLAINTEXT"
    },
    {
      name  = "DOMAIN_NAME"
      value = var.domain_name
      type  = "PLAINTEXT"
    },
    {
      name  = "USERNAME"
      value = "test"
      type  = "PLAINTEXT"
    },
    {
      name  = "CONTROL_PLANE_HOST"
      value = var.control_plane_host
      type  = "PLAINTEXT"
    },
    {
      name  = "ACCESS_TOKEN_EXPIRATION"
      value = 3600
      type  = "PLAINTEXT"
    },
    {
      name  = "REFRESH_TOKEN_EXPIRATION"
      value = 3600
      type  = "PLAINTEXT"
    },
    {
      name  = "AUTH_CODE_EXPIRATION"
      value = 3600
      type  = "PLAINTEXT"
    },
    {
      name  = "TENANT_CLIENT_ID"
      value = "/${var.namespace}/${var.environment}/pooled/tenant_client_id"
      type  = "PARAMETER_STORE"
    },
    {
      name  = "TENANT_CLIENT_SECRET"
      value = "/${var.namespace}/${var.environment}/pooled/tenant_client_secret"
      type  = "PARAMETER_STORE"
    }
  ]

  cloudwatch_log_group_name  = var.standard_cloudwatch_log_group_name
  cloudwatch_log_stream_name = var.cloudwatch_log_stream_name

  enable_codebuild_authentication = false
  # source_credential_auth_type     = "PERSONAL_ACCESS_TOKEN"
  # source_credential_server_type   = "GITHUB"
  # source_credential_token         = data.aws_ssm_parameter.github_token.value

  tags       = module.tags.tags
  depends_on = [module.tenant_ssm_parameters, aws_codecommit_repository.standard_repo]
}

resource "aws_codecommit_repository" "standard_repo" {
  repository_name = "${var.namespace}-${var.environment}-standard-plan-repository"
  description     = "${var.namespace}-${var.environment}-standard-repository."
  default_branch  = "main"

  lifecycle {
    prevent_destroy = true
  }
}


#####################################################################################
## Tenant Helm Chart CodeCommit Repository
#####################################################################################
resource "aws_codecommit_repository" "tenant_helm_repo" {
  repository_name = "${var.namespace}-${var.environment}-tenant-management-gitops-repository"
  description     = "${var.namespace}-${var.environment}-tenant-management-gitops-repository."
  default_branch  = "main"

  lifecycle {
    prevent_destroy = true
  }
}