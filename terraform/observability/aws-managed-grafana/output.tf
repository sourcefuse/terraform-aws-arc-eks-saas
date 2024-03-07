output "grafana_url" {
  description = "Amazon Managed Grafana Workspace endpoint"
  value       = module.grafana.grafana_workspace_endpoint

}

output "grafana_workspace_id" {
  description = "Amazon Managed Grafana Workspace ID"
  value       = module.grafana.grafana_workspace_id
}

output "grafana_workspace_iam_role_arn" {
  description = "Amazon Managed Grafana Workspace's IAM Role ARN"
  value       = module.grafana.grafana_workspace_iam_role_arn
}


output "grafana_api_key" {
  value     = module.grafana.granafa_workspace_api_key
  sensitive = true
}