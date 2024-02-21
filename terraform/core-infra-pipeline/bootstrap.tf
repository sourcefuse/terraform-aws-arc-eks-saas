
################################################################################
## Tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

################################################################################
## Codebuild
################################################################################
resource "aws_codebuild_project" "initial_bootstrap" {
  name           = "initial-bootstrap-${var.namespace}-${var.environment}"
  description    = " Initial bootstrap"
  build_timeout  = 480
  queued_timeout = 480

  service_role = aws_iam_role.bootstrap_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }



  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "aws_region"
      value = var.region
    }

    environment_variable {
      name  = "namespace"
      value = var.namespace
    }

    environment_variable {
      name  = "environment"
      value = var.environment
    }

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "terraform/bootstrap/buildspec-bootstrap.yaml"
  }

  tags = module.tags.tags
}


resource "aws_iam_role" "bootstrap_role" {
  name = "initial-bootstrap-role-${var.namespace}-${var.environment}"

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


resource "aws_iam_role_policy_attachment" "initial_bootstrap_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.bootstrap_role.name
}
