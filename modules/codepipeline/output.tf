output "id" {
  value       = aws_codepipeline.deployment_pipeline.id
  description = "The id of the CodePipeline"
}

output "name" {
  value       = aws_codepipeline.deployment_pipeline.name
  description = "The name of the CodePipeline"
}

output "arn" {
  value       = aws_codepipeline.deployment_pipeline.arn
  description = "The arn of the CodePipeline"
}