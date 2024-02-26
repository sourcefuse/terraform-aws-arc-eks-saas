output "domain_id" {
  value       = module.opensearch.domain_id
  description = "Unique identifier for the OpenSearch domain"
}

output "opensearch_name" {
  value       = trimprefix(module.opensearch.domain_id, "${data.aws_caller_identity.this.account_id}/")
  description = "OpenSearch cluster name."
}