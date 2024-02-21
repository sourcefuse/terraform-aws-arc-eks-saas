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

output "aurora" {
  value = [

    data.aws_security_groups.aurora.ids
  ]
  description = "Security groups that are allowed to access the RDS"
}

output "rds_instance_endpoint" {
  value       = module.aurora.rds_instance_endpoint
  description = "The DNS address to the RDS Instance."
}