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
   version = "4.1.1"

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

## CUR Report
resource "aws_cur_report_definition" "cur" {
  report_name                = local.cur_report_name
  time_unit                  = "DAILY"
  format                     = "Parquet"
  compression                = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                  = module.cur_bucket.s3_bucket_id
  s3_prefix                  = "reports"
  s3_region                  = var.region
  additional_artifacts       = ["ATHENA"]
}