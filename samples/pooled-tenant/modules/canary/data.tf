
data "aws_s3_bucket" "s3_canaries-reports" {
  bucket = var.reports-bucket
}

data "aws_iam_role" "role" {
  name = var.role
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}