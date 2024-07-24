data "aws_ssm_parameter" "orchestrator_ecr_image" {
    name = "/${var.namespace}/${var.environment}/orchestration-ecr-image-uri"
}

