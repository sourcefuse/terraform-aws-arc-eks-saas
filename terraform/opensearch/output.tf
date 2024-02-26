output "domain_id" {
  value       = module.opensearch.domain_id
  description = "Unique identifier for the OpenSearch domain"
}

output "opensearch_name" {
  value       = trimprefix(module.opensearch.domain_id, "${data.aws_caller_identity.this.account_id}/")
  description = "OpenSearch cluster name."
}

output "domain_arn" {
  value       = module.opensearch.domain_arn
  description = "ARN of the OpenSearch domain"
}

output "domain_endpoint" {
  value       = module.opensearch.domain_endpoint
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
}

output "kibana_endpoint" {
  value       = module.opensearch.kibana_endpoint
  description = "Domain-specific endpoint for Kibana without https scheme"
}

output "domain_hostname" {
  value       = module.opensearch.domain_hostname
  description = "OpenSearch domain hostname to submit index, search, and data upload requests"
}

output "kibana_hostname" {
  value       = module.opensearch.kibana_hostname
  description = "Kibana hostname"
}