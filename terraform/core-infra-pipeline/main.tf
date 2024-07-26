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

# resource "aws_iam_role_policy_attachment" "codepipeline_role_attachment" {
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
#   role       = "TerraformCodePipelineRole-${var.namespace}-${var.environment}"

#   depends_on = [module.codepipeline_role]
# }

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
    { name = "Bootstrap", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 2, project_name = "${module.initial_bootstrap.name}" },
    { name = "Networking", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 3, project_name = "${module.networking_module_build_step_codebuild_project.name}" },
    { name = "Database", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 4, project_name = "${aws_codebuild_project.rds_module_build_step_codebuild_project.name}" },
    { name = "Elasticache", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 4, project_name = "${module.elasticache_module_build_step_codebuild_project.name}" },
    { name = "Opensearch", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 4, project_name = "${module.opensearch_module_build_step_codebuild_project.name}" },
    { name = "ClientVPN", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 4, project_name = "${module.vpn_module_build_step_codebuild_project.name}" },
    { name = "IAMRole", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 5, project_name = "${module.iam_role_module_build_step_codebuild_project.name}" },
    { name = "EKS", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 6, project_name = "${module.eks_module_build_step_codebuild_project.name}" },
    { name = "EKS-Auth", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 7, project_name = "${module.eks_auth_module_build_step_codebuild_project.name}" },
    { name = "EKS-Istio", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 7, project_name = "${module.istio_module_build_step_codebuild_project.name}" },
    { name = "Observability", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 7, project_name = "${module.eks_observability_module_build_step_codebuild_project.name}" },
    { name = "Opensearch-Ops", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 7, project_name = "${aws_codebuild_project.os_ops_module_build_step_codebuild_project.name}" },
    { name = "Cognito", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 8, project_name = "${module.cognito_module_build_step_codebuild_project.name}" },
    { name = "TenantCodebuilds", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 8, project_name = "${module.tenant_codebuild_module_build_step_codebuild_project.name}" },
    { name = "ControlPlaneApplication", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 8, project_name = "${module.control_plane_module_build_step_codebuild_project.name}" },
    { name = "Decoupling-Infra", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 8, project_name = "${module.decoupling_module_build_step_codebuild_project.name}" },
    { name = "Billing", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 8, project_name = "${module.billing_module_build_step_codebuild_project.name}" },
    { name = "WAF", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "source_output", output_artifacts = "", run_order = 8, project_name = "${module.waf_module_build_step_codebuild_project.name}" }
  ]
  tags = module.tags.tags

  depends_on = [module.initial_bootstrap,
    module.networking_module_build_step_codebuild_project,
    aws_codebuild_project.rds_module_build_step_codebuild_project,
    module.elasticache_module_build_step_codebuild_project,
    module.opensearch_module_build_step_codebuild_project,
    aws_codebuild_project.os_ops_module_build_step_codebuild_project,
    module.iam_role_module_build_step_codebuild_project,
    module.eks_module_build_step_codebuild_project,
    module.eks_auth_module_build_step_codebuild_project,
    module.tenant_codebuild_module_build_step_codebuild_project,
    module.cognito_module_build_step_codebuild_project,
    module.vpn_module_build_step_codebuild_project,
    module.control_plane_module_build_step_codebuild_project,
    module.istio_module_build_step_codebuild_project,
    module.eks_observability_module_build_step_codebuild_project,
    module.decoupling_module_build_step_codebuild_project,
    module.billing_module_build_step_codebuild_project,
  module.waf_module_build_step_codebuild_project]
}
