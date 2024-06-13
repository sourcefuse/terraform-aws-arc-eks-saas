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
  backup_selection_data = {
    name      = "${var.tenant}-backup-selection"
    plan_name = local.backup_plan_name
    resources = ["*"]
    selection_tags = [
      {
        type  = "STRINGEQUALS"
        key   = "Name"
        value = "aurora"
      },
      {
        type  = "STRINGEQUALS"
        key   = "Tenant"
        value = "${var.tenant}"
      },
      {
        type  = "STRINGEQUALS"
        key   = "Tenant_ID"
        value = "${var.tenant_id}"
      }
    ]
  }


  tags = module.tags.tags

}

resource "null_resource" "backup_job" {
  provisioner "local-exec" {
    command = <<EOF
#!/bin/bash
set -e

# Start the backup job
aws backup start-backup-job --backup-vault-name "${local.vault_name}" --resource-arn "arn:aws:rds:${var.region}:${data.aws_caller_identity.current.account_id}:cluster:${var.namespace}-${var.environment}-${var.tenant}-aurora" --iam-role-arn "${module.backup.backup_role_arn}" | tee response

# Extract the Backup Job ID
BACKUP_JOB_ID=$(jq -r ".BackupJobId" < response)

# Monitor the backup job status
until [ "${STATE:=RUNNING}" = "COMPLETED" ]
do
  echo "Current status: '${STATE}' wait 10 seconds."
  sleep 10
  aws backup describe-backup-job --backup-job-id "${BACKUP_JOB_ID}" | tee response
  STATE=$(jq -r ".State" < response)
done

echo "Current status: '${STATE}'"
EOF
  }
}
