################################################################################
## tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Tenant    = var.tenant
    Tenant_ID = var.tenant_id
  }

}

module "backup" {
  source                   = "sourcefuse/arc-backup/aws"
  version = "0.0.1"
  backup_vault_data        = {
    name                            = local.vault_name
    enable_encryption               = true
    backup_role_name                = local.backup_role_name
    kms_key_deletion_window_in_days = 7
    kms_key_admin_arns              = []
  }
  backup_plan              = local.backup_plan_name
  create_role              = true
  role_name                = local.backup_role_name
  backup_selection_data    = {
    name      = "${var.tenant}-backup-selection"
    plan_name = local.backup_plan_name
    resources = ["arn:aws:rds:us-west-2:471112653618:db:sf-arc-saas-dev-preemium-aurora-1"]
    
  }


  tags = module.tags.tags

}