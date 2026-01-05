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
    Tier = var.tenant_tier
  }

}

module "backup" {
  source  = "sourcefuse/arc-backup/aws"
  version = "0.0.1"
  backup_vault_data = {
    name                            = local.vault_name
    enable_encryption               = true
    backup_role_name                = local.backup_role_name
    kms_key_deletion_window_in_days = 7
    kms_key_admin_arns              = []
  }

  backup_plan = null
  create_role = true
  role_name   = local.backup_role_name
  backup_selection_data = null

  tags = module.tags.tags

}

resource "null_resource" "run_backup_script" {
  provisioner "local-exec" {
    command = "bash ./start_backup_job.sh"
    environment = {
      BACKUP_VAULT_NAME = local.vault_name
      RESOURCE_ARN      = data.aws_ssm_parameter.db_arn.value
      IAM_ROLE_ARN      = module.backup.backup_role_arn
    }
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [module.backup]
}

