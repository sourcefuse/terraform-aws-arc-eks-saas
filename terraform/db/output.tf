## aurora
output "aurora_endpoints" {
  value = [
    for rds in module.aurora : rds.aurora_endpoint
  ]
  description = "The DNS address of the Aurora instance"
}

output "aurora_arns" {
  value = [
    for rds in module.aurora : rds.aurora_arn
  ]
  description = "Amazon Resource Name (ARN) of cluster"
}


output "aurora_reader_endpoint" {
  value = [
    for rds in module.aurora : rds.aurora_reader_endpoint
  ]
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "aurora" {
  value = [

    data.aws_security_groups.aurora.ids
  ]
  description = "Security groups that are allowed to access the RDS"
}