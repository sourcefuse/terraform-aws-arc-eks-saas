output "managed_prometheus_workspace_id" {
  value       = module.prometheus.managed_prometheus_workspace_id
  description = "Amazon Managed Workspace ID"
}

output "managed_prometheus_workspace_endpoint" {
  value       = module.prometheus.managed_prometheus_workspace_endpoint
  description = "Amazon managed workspace endpoint"
}