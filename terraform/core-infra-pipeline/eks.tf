#############################################################################################
## Codebuild Role
#############################################################################################
module "eks_module_build_step_role" {
  source           = "../../modules/iam-role"
  role_name        = "terraform-eks-module-build-step-role-${var.namespace}-${var.environment}"
  role_description = "terraform eks module build step role"
  principals = {
    "Service" : ["codebuild.amazonaws.com"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json)
  ]
  policy_name        = "terraform-eks-module-build-step-policy-${var.namespace}-${var.environment}"
  policy_description = "terraform eks module build step role"
  tags               = module.tags.tags
}

#############################################################################################
## Codebuild Project
#############################################################################################
module "eks_module_build_step_codebuild_project" {
  source                            = "../../modules/codebuild"
  name                              = "terraform-eks-module-build-step-code-build-${var.namespace}-${var.environment}"
  description                       = "terraform eks module build step module code build project"
  build_timeout                     = 480
  queued_timeout                    = 480
  service_role                      = module.eks_module_build_step_role.arn
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
          "export PATH=$PWD/:$PATH",
          "apt-get update -y && apt-get install -y jq unzip",
          "curl -sS -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator",
          "curl -sS -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl",
          "chmod +x ./kubectl ./aws-iam-authenticator"
        ]
      }

      pre_build = {
        commands = [
          "cd terraform/eks",
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
          "terraform plan ",
          "terraform apply  --auto-approve",
          "terraform apply  --var=\"enable_karpenter=true\" --auto-approve",
          "terraform apply --var=\"enable_karpenter=true\" --var=\"add_role_to_ssm=true\" --auto-approve",
        ]
      }
    }
  })

  tags = module.tags.tags
}
