locals {
  backup_plan_name = "${var.tenant_tier}-${var.tenant}-backup-plan"
  backup_role_name = "${var.tenant_tier}-${var.tenant}-backup-role"
  vault_name       = "${var.tenant_tier}-${var.tenant}-backup-vault"
}