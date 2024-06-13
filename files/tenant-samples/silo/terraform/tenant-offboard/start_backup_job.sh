#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if required environment variables are set
if [ -z "$BACKUP_VAULT_NAME" ] || [ -z "$RESOURCE_ARN" ] || [ -z "$IAM_ROLE_ARN" ]; then
  echo "Error: BACKUP_VAULT_NAME, RESOURCE_ARN, and IAM_ROLE_ARN must be set."
  exit 1
fi

# Start the backup job
echo "Starting backup job..."
aws backup start-backup-job \
  --backup-vault-name "$BACKUP_VAULT_NAME" \
  --resource-arn "$RESOURCE_ARN" \
  --iam-role-arn "$IAM_ROLE_ARN" \
  | tee response

# Extract the Backup Job ID
BACKUP_JOB_ID=$(jq -r ".BackupJobId" < response)
if [ -z "$BACKUP_JOB_ID" ]; then
  echo "Error: Failed to retrieve Backup Job ID."
  exit 1
fi
echo "Backup Job ID: $BACKUP_JOB_ID"

# Monitor the backup job status
STATE="RUNNING"
echo "Monitoring backup job status..."
until [ "$STATE" = "COMPLETED" ] || [ "$STATE" = "FAILED" ]; do
  echo "Current status: '$STATE' - waiting 30 seconds."
  sleep 30
  aws backup describe-backup-job --backup-job-id "$BACKUP_JOB_ID" | tee response
  STATE=$(jq -r ".State" < response)
done

if [ "$STATE" = "COMPLETED" ]; then
  echo "Backup completed successfully."
else
  echo "Backup job failed with status: $STATE."
  exit 1
fi
