output "backup_role_arn" {
  description = "IAM Role for taking backups"
  value       = module.backup.backup_role_arn
}

output "backup_plan_id" {
  description = "AWS backups plan ID"
  value       = module.backup.backup_plan_id
}

output "vault_arn" {
  description = "Vault ARN"
  value       = module.backup.vault_arn
}
