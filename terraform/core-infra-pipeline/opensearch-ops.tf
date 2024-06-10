#############################################################################################
## Codebuild Role
#############################################################################################
module "os_ops_module_build_step_role" {
  source           = "../../modules/iam-role"
  role_name        = "terraform-opensearch-ops-module-build-step-role-${var.namespace}-${var.environment}"
  role_description = "terraform opensearch ops module build step role"
  principals = {
    "Service" : ["codebuild.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "terraform-opensearch-ops-module-build-step-policy-${var.namespace}-${var.environment}"
  policy_description = "terraform opensearch ops module build step policy"
  tags               = module.tags.tags
}

#############################################################################################
## Codebuild Project
#############################################################################################
resource "aws_codebuild_project" "os_ops_module_build_step_codebuild_project" {
  name           = "terraform-opensearch-ops-module-build-step-code-build-${var.namespace}-${var.environment}"
  description    = "terraform opensearch ops module build step module code build project"
  build_timeout  = 480
  queued_timeout = 480

  service_role = module.os_ops_module_build_step_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

  }
  source {
    type = "CODEPIPELINE"
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
            "tf_state_bucket=$(aws ssm get-parameter --name \"/${var.namespace}/${var.environment}/terraform-state-bucket\" --query \"Parameter.Value\" --output text --region ${var.region})",
            "tf_state_table=$(aws ssm get-parameter --name \"/${var.namespace}/${var.environment}/terraform-state-dynamodb-table\" --query \"Parameter.Value\" --output text --region ${var.region})",
            "cd terraform/opensearch-ops",
            "rm config.hcl",
            "sed -i 's/aws_region/${var.region}/g' config.txt",
            "envsubst < config.txt > config.${var.environment}.hcl",
          ]
        }

        build = {
          commands = [
            "terraform init --backend-config=config.${var.environment}.hcl",
            "terraform plan",
            "terraform apply -auto-approve",
          ]
        }
      }
    })
  }


  tags = module.tags.tags
}
