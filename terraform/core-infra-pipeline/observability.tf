#############################################################################################
## Codebuild Role
#############################################################################################
module "eks_observability_module_build_step_role" {
  source           = "../../modules/iam-role"
  role_name        = "terraform-eks-observability-role-${var.namespace}-${var.environment}"
  role_description = "terraform eks observability module build step role"
  principals = {
    "Service" : ["codebuild.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "terraform-eks-observability-policy-${var.namespace}-${var.environment}"
  policy_description = "terraform eks observability module build step role"
  tags               = module.tags.tags
}

#############################################################################################
## Codebuild Project
#############################################################################################
module "eks_observability_module_build_step_codebuild_project" {
  source                            = "../../modules/codebuild"
  name                              = "terraform-eks-observability-module-build-step-code-build-${var.namespace}-${var.environment}"
  description                       = "terraform eks observability build step module code build project"
  build_timeout                     = 480
  queued_timeout                    = 480
  service_role                      = module.eks_observability_module_build_step_role.arn
  artifact_type                     = "CODEPIPELINE"
  build_compute_type                = "BUILD_GENERAL1_SMALL"
  build_image                       = "aws/codebuild/standard:6.0"
  build_type                        = "LINUX_CONTAINER"
  build_image_pull_credentials_type = "CODEBUILD"
  environment_variables = [
    {
      name  = "aws_region"
      value = var.region
      type  = "PLAINTEXT"
    },
    {
      name  = "namespace"
      value = var.namespace
      type  = "PLAINTEXT"
    },
    {
      name  = "environment"
      value = var.environment
      type  = "PLAINTEXT"
    }
  ]

  source_type = "CODEPIPELINE"


  buildspec = "terraform/observability/self-hosted-grafana/buildspec.yaml"

  tags = module.tags.tags
}
