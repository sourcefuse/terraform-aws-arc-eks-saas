region         = "${REGION}"
key            = "tenant-codebuild/terraform.tfstate"
bucket         = "${TF_STATE_BUCKET}"
dynamodb_table = "${TF_STATE_TABLE}"
encrypt        = true