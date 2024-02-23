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
    Service = "codepipeline.amazonaws.com"
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "TerraformCodePipelinePolicy-${var.namespace}-${var.environment}"
  policy_description = "TerraformCodePipelinePolicy"
  tags               = module.tags.tags
}
# resource "aws_iam_role" "codepipeline_role" {
#   name = "TerraformCodePipelineRole-${var.namespace}-${var.environment}"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "codepipeline.amazonaws.com"
#         }
#       }
#     ]
#   })
# }


# resource "aws_iam_role_policy_attachment" "admin_fullaccess" {

#   role = aws_iam_role.codepipeline_role.name

#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
# }

############################################################################################
## Codepipeline
############################################################################################
module "deployment_pipeline" {
  source = "../../modules/codepipeline"


  name           = "${var.namespace}-${var.environment}-terraform-pipeline"
  role_arn       = aws_iam_role.codepipeline_role.arn
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
# resource "aws_codepipeline" "deployment_pipeline" {

#   depends_on = [aws_codebuild_project.initial_bootstrap,
#     aws_codebuild_project.networking_module_build_step_codebuild_project,
#     aws_codebuild_project.rds_module_build_step_codebuild_project,
#   aws_codebuild_project.elasticache_module_build_step_codebuild_project]

#   name     = "${var.namespace}-${var.environment}-terraform-pipeline"
#   role_arn = aws_iam_role.codepipeline_role.arn

#   artifact_store {
#     location = data.aws_ssm_parameter.artifact_bucket.value
#     type     = "S3"
#   }

#   stage {
#     name = "Source"

#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "AWS"
#       provider         = "CodeStarSourceConnection"
#       version          = "1"
#       output_artifacts = ["source_output"]

#       configuration = {

#         ConnectionArn    = data.aws_codestarconnections_connection.existing_github_connection.arn
#         FullRepositoryId = var.github_FullRepositoryId
#         BranchName       = var.github_BranchName

#       }
#     }
#   }

#   stage {
#     name = "Bootstrap"

#     action {
#       name            = "Bootstrap"
#       category        = "Build"
#       owner           = "AWS"
#       provider        = "CodeBuild"
#       version         = "1"
#       input_artifacts = ["source_output"]
#       #output_artifacts = ["build_output"]

#       configuration = {
#         ProjectName = aws_codebuild_project.initial_bootstrap.name
#       }
#     }
#   }

#   stage {
#     name = "Networking"

#     action {
#       name            = "Networking"
#       category        = "Build"
#       owner           = "AWS"
#       provider        = "CodeBuild"
#       version         = "1"
#       input_artifacts = ["source_output"]
#       #output_artifacts = ["build_output"]

#       configuration = {
#         ProjectName = aws_codebuild_project.networking_module_build_step_codebuild_project.name
#       }
#     }
#   }

#   stage {
#     name = "Data-Services"

#     action {
#       name            = "Database"
#       category        = "Build"
#       owner           = "AWS"
#       provider        = "CodeBuild"
#       version         = "1"
#       input_artifacts = ["source_output"]
#       #output_artifacts = ["build_output"]

#       configuration = {
#         ProjectName = aws_codebuild_project.rds_module_build_step_codebuild_project.name
#       }
#     }

#     action {
#       name            = "Elasticache"
#       category        = "Build"
#       owner           = "AWS"
#       provider        = "CodeBuild"
#       version         = "1"
#       input_artifacts = ["source_output"]
#       #output_artifacts = ["build_output"]

#       configuration = {
#         ProjectName = aws_codebuild_project.elasticache_module_build_step_codebuild_project.name
#       }
#     }

#   }

#   tags = module.tags.tags
# }