#########################################################################
## default
#########################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }

  backend "s3" {}
}



provider "aws" {
  region = var.region
}


################################################################################
## Tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}
#######################################################################################
## CodePipeline Role
#######################################################################################
module "codepipeline_role" {
  source           = "../../modules/iam-role"
  role_name        = "TerraformCodePipelineRole-${var.namespace}-${var.environment}"
  role_description = "TerraformCodePipelineRole"
  principals = {
    "Service" = ["codepipeline.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "TerraformCodePipelinePolicy-${var.namespace}-${var.environment}"
  policy_description = "TerraformCodePipelinePolicy"
  tags               = module.tags.tags
}

############################################################################################
## Codepipeline
############################################################################################
module "deployment_pipeline" {
  source = "../../modules/codepipeline"


  name           = "${var.namespace}-${var.environment}-terraform-pipeline"
  role_arn       = module.codepipeline_role.arn
  s3_bucket_name = data.aws_ssm_parameter.artifact_bucket.value

  ConnectionArn      = data.aws_codestarconnections_connection.existing_github_connection.arn
  source_repo_name   = var.github_FullRepositoryId
  source_repo_branch = var.github_BranchName
  stages = [
    { name = "Bootstrap", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = "2", project_name = "${module.initial_bootstrap.name}" },
    { name = "Networking", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = "3", project_name = "${module.networking_module_build_step_codebuild_project.name}" },
    { name = "Database", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = "4", project_name = "${module.rds_module_build_step_codebuild_project.name}" },
    { name = "Elasticache", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = "4", project_name = "${module.elasticache_module_build_step_codebuild_project.name}" }
  ]
  tags = module.tags.tags

  depends_on = [module.initial_bootstrap,
    module.networking_module_build_step_codebuild_project,
    module.rds_module_build_step_codebuild_project,
  module.elasticache_module_build_step_codebuild_project]
}
