locals {
  backup_plan_name = "${var.tenant}-backup-plan"
  backup_role_name = "${var.tenant}-backup-restore"
  vault_name       = "${var.tenant}-backup-vault"
}