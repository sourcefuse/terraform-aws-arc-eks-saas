region         = "us-east-1"
key            = "network/terraform.tfstate"
bucket         = "arc-saas-dev-terraform-state"
dynamodb_table = "arc-saas-dev-terraform-state-lock"
encrypt        = true