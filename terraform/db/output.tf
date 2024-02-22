## aurora
output "aurora_endpoints" {
  value       = module.aurora.aurora_endpoint
  description = "The DNS address of the Aurora instance"
}

output "aurora_arns" {
  value       = module.aurora.aurora_arn
  description = "Amazon Resource Name (ARN) of cluster"
}


output "aurora_reader_endpoint" {
  value       = module.aurora.aurora_reader_endpoint
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "aurora_security_group" {
  value       = [data.aws_security_groups.aurora.ids]
  description = "Security groups that are allowed to access the RDS"
}

output "aurora_master_host" {
  value       = module.aurora.aurora_master_host
  description = "DB Master hostname"
}

output "aurora_replicas_host" {
  value       = module.aurora.aurora_replicas_host
  description = "Replicas hostname"
}