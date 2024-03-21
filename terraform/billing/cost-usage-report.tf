#########################################################################
## Cost & Usage Report
#########################################################################
module "bucket_suffix" {
  source     = "../../modules/random-password"
  length     = 6
  is_special = false
  is_upper   = false
}

module "cur" {
  source = "../../modules/cost-usage-report"

  use_existing_s3_bucket  = false
  s3_bucket_name          = "${var.namespace}-${var.environment}-${var.region}-${module.bucket_suffix.result}-cur-bucket"
  s3_bucket_prefix        = "reports"
  s3_use_existing_kms_key = true
  s3_kms_key_alias        = "aws/s3"

  report_name      = local.cur_report_name
  report_frequency = "DAILY"
  report_additional_artifacts = [
    "ATHENA",
  ]

  report_format      = "Parquet"
  report_compression = "Parquet"
  report_versioning  = "OVERWRITE_REPORT"

  tags = module.tags.tags

}