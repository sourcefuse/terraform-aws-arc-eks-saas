########################################################################################
## Codebuild Project
########################################################################################
module "initial_bootstrap" {
  source                            = "../../modules/codebuild"
  name                              = "initial-bootstrap-${var.namespace}-${var.environment}"
  description                       = " Initial bootstrap"
  build_timeout                     = 480
  queued_timeout                    = 480
  service_role                      = module.bootstrap_role.arn
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
  buildspec   = "terraform/bootstrap/buildspec-bootstrap.yaml"

  tags = module.tags.tags


}

#############################################################################################
## Codebuild Role
#############################################################################################
module "bootstrap_role" {
  source           = "../../modules/iam-role"
  role_name        = "initial-bootstrap-role-${var.namespace}-${var.environment}"
  role_description = "initial-bootstrap-role"
  principals = {
    "Service" : ["codebuild.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "initial-bootstrap-policy-${var.namespace}-${var.environment}"
  policy_description = "initial-bootstrap-policy"
  tags               = module.tags.tags
}
