output "state_bucket_arn" {
  value       = module.bootstrap.bucket_arn
  description = "State bucket ARN"
}

output "state_bucket_name" {
  sensitive   = true
  value       = module.bootstrap.bucket_name
  description = "State bucket name"
}

output "state_lock_table_arn" {
  value       = module.bootstrap.dynamodb_arn
  description = "State lock table ARN"
}

output "state_lock_table_name" {
  value       = module.bootstrap.dynamodb_name
  description = "State lock table name"
}