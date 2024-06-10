#############################################################################################
## Codebuild Role
#############################################################################################
module "opensearch_module_build_step_role" {
  source           = "../../modules/iam-role"
  role_name        = "terraform-opensearch-module-build-step-role-${var.namespace}-${var.environment}"
  role_description = "terraform opensearch module build step role"
  principals = {
    "Service" : ["codebuild.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "terraform-opensearch-module-build-step-policy-${var.namespace}-${var.environment}"
  policy_description = "terraform opensearch module build step policy"
  tags               = module.tags.tags
}

#############################################################################################
## Codebuild Project
############################################module#################################################
module "opensearch_module_build_step_codebuild_project" {
  source                            = "../../modules/codebuild"
  name                              = "terraform-opensearch-module-build-step-code-build-${var.namespace}-${var.environment}"
  description                       = "terraform opensearch module build step module code build project"
  build_timeout                     = 480
  queued_timeout                    = 480
  service_role                      = module.opensearch_module_build_step_role.arn
  artifact_type                     = "CODEPIPELINE"
  build_compute_type                = "BUILD_GENERAL1_SMALL"
  build_image                       = "aws/codebuild/standard:6.0"
  build_type                        = "LINUX_CONTAINER"
  build_image_pull_credentials_type = "CODEBUILD"
  environment_variables             = []

  source_type = "CODEPIPELINE"
  buildspec = yamlencode({
    version = "0.2"

    phases = {
      install = {
        commands = [
          "curl -o /usr/local/bin/terraform.zip https://releases.hashicorp.com/terraform/1.7.1/terraform_1.7.1_linux_amd64.zip",
          "unzip /usr/local/bin/terraform.zip -d /usr/local/bin/",
          "terraform --version",
        ]
      }

      pre_build = {
        commands = [
          "export PATH=$PWD/:$PATH",
          "apt-get update -y && apt-get install -y jq unzip",
          "cd terraform/opensearch",
          "rm config.hcl",
          "sed -i 's/aws_region/${var.region}/g' config.txt",
          "tf_state_bucket=$(aws ssm get-parameter --name \"/${var.namespace}/${var.environment}/terraform-state-bucket\" --query \"Parameter.Value\" --output text --region ${var.region})",
          "tf_state_table=$(aws ssm get-parameter --name \"/${var.namespace}/${var.environment}/terraform-state-dynamodb-table\" --query \"Parameter.Value\" --output text --region ${var.region})",
          "envsubst < config.txt > config.${var.environment}.hcl",

        ]
      }

      build = {
        commands = [
          "terraform init --backend-config=config.${var.environment}.hcl",
          "terraform plan",
          "terraform apply -auto-approve",
          "export vpc_id=$(aws ec2 describe-vpcs --filters \"Name=tag:Name,Values=${var.namespace}-${var.environment}-vpc\" --query \"Vpcs[].VpcId\" --output text)",
          "export subnet_ids_first=$(aws ec2 describe-subnets --filters \"Name=tag:Name,Values=${var.namespace}-${var.environment}-private-subnet-private-${var.region}a\" --query \"Subnets[].SubnetId\" --output text)",
          "export subnet_ids_second=$(aws ec2 describe-subnets --filters \"Name=tag:Name,Values=${var.namespace}-${var.environment}-private-subnet-private-${var.region}b\" --query \"Subnets[].SubnetId\" --output text)",
          "export sec_id=$(aws ec2 describe-security-groups --filters \"Name=group-name,Values=${var.namespace}-${var.environment}-codebuild-db-access\" --query \"SecurityGroups[*].{ID:GroupId}\" --output text)",
          "aws codebuild update-project  --name \"terraform-opensearch-ops-module-build-step-code-build-${var.namespace}-${var.environment}\" --vpc-config \"vpcId=$vpc_id,subnets=[$subnet_ids_first,$subnet_ids_second],securityGroupIds=[$sec_id]\" --region \"${var.region}\"",
        ]
      }
    }
  })

  tags = module.tags.tags
}
