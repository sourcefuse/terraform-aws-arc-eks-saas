output "name" {
  description = "Project name"
  value       = join("", aws_codebuild_project.codebuild_project[*].name)
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = join("", aws_codebuild_project.codebuild_project[*].badge_url)
}

output "project_arn" {
  description = "Project ARN"
  value       = join("", aws_codebuild_project.codebuild_project[*].arn)
}