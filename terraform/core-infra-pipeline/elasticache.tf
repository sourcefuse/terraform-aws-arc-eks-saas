#############################################################################################
## Codebuild Role
#############################################################################################
resource "aws_iam_role" "elasticache_module_build_step_role" {
  name = "terraform-elasticache-module-build-step-role-${var.namespace}-${var.environment}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codebuild.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elasticache_module_build_step_policy_attachment_admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.elasticache_module_build_step_role.name
}

#############################################################################################
## Codebuild Project
#############################################################################################
resource "aws_codebuild_project" "elasticache_module_build_step_codebuild_project" {
  name           = "terraform-elasticache-module-build-step-code-build-${var.namespace}-${var.environment}"
  description    = "terraform iam module build step module code build project"
  build_timeout  = 480
  queued_timeout = 480

  service_role = aws_iam_role.elasticache_module_build_step_role.arn

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
            "cd terraform/elasticache",
            "rm config.${var.environment}.hcl",
            "sed -i 's/aws_region/${var.region}/g' config.txt",
            "tf_state_bucket=$(aws ssm get-parameter --name \"/${var.namespace}/${var.environment}/terraform-state-bucket\" --query \"Parameter.Value\" --output text --region ${var.region})",
            "envsubst < config.txt > config.${var.environment}.hcl",

          ]
        }


        build = {
          commands = [
            "terraform init --backend-config=config.${var.environment}.hcl",
            "terraform plan --var-file=${var.environment}.tfvars",
            "terraform apply --var-file=${var.environment}.tfvars -auto-approve",
          ]
        }
      }
    })
  }
  tags = module.tags.tags
}
