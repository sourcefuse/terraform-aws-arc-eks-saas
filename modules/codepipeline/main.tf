terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}


resource "aws_codepipeline" "deployment_pipeline" {
  name     = var.name
  role_arn = var.role_arn

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeStarSourceConnection"
      output_artifacts = ["source_output"]

      configuration = {
        FullRepositoryId = var.source_repo_name
        BranchName       = var.source_repo_branch
        ConnectionArn    = var.ConnectionArn
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages

    content {
      name = "Stage-${stage.value["name"]}"
      action {
        category         = stage.value["category"]
        name             = "Action-${stage.value["name"]}"
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        input_artifacts  = [stage.value["input_artifacts"]]
        output_artifacts = [stage.value["output_artifacts"]]
        version          = "1"
        run_order        = stage.value["run_order"]

        configuration = {
          ProjectName = stage.value["project_name"]
        }
      }
    }
  }
  tags = var.tags
}