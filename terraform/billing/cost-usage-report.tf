#########################################################################
## Cost & Usage Report
#########################################################################
module "bucket_suffix" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}


module "cur_bucket" {
   source  = "terraform-aws-modules/s3-bucket/aws"
   version = "~> 3.0"

   bucket = "${var.namespace}-${var.environment}-cur-bucket-${module.bucket_suffix.result}"
   acl    = "private"

   force_destroy = true

   # Bucket policies
   attach_policy           = true
   policy                  = data.aws_iam_policy_document.bucket_policy.json

   block_public_acls       = true
   block_public_policy     = true
   ignore_public_acls      = true
   restrict_public_buckets = true

   tags = module.tags.tags
 }


module "this" {
  source = "../../modules/cost-usage-report"

  use_existing_s3_bucket  = true
  s3_bucket_name          = "${var.namespace}-${var.environment}-cur-bucket-${module.bucket_suffix.result}"
  s3_bucket_prefix        = "reports"
  s3_use_existing_kms_key = true
  s3_kms_key_alias        = "aws/s3"

  report_name      = local.cur_report_name
  report_frequency = "HOURLY"
  report_additional_artifacts = [
    "ATHENA",
  ]

  report_format      = "Parquet"
  report_compression = "Parquet"
  report_versioning  = "OVERWRITE_REPORT"

  tags = module.tags.tags
}