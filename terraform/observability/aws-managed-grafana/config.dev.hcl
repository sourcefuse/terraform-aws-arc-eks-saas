region         = "${REGION}"
key            = "eks-aws-managed-grafana/terraform.tfstate"
bucket         = "${TF_STATE_BUCKET}"
dynamodb_table = "${TF_STATE_TABLE}"
encrypt        = true