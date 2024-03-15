output "s3_bucket_name" {
  description = "Name of S3 bucket used for storing CUR data. This may be provisioned by this module or not."
  value       = aws_cur_report_definition.this.s3_bucket
}

output "s3_bucket_prefix" {
  description = "Prefix used for storing CUR data inside the S3 bucket."
  value       = aws_cur_report_definition.this.s3_bucket
}

output "s3_bucket_arn" {
  description = "ARN of S3 bucket used for storing CUR data. This may be provisioned by this module or not."
  value       = coalescelist(aws_s3_bucket.cur.*.arn, data.aws_s3_bucket.cur.*.arn)[0]
}

output "s3_bucket_region" {
  description = "Region where the S3 bucket used for storing CUR data is provisioned. This may be provisioned by this module or not."
  value       = aws_cur_report_definition.this.s3_region
}

output "report_name" {
  description = "Name of the provisioned Cost and Usage Report."
  value       = aws_cur_report_definition.this.report_name
}

output "lambda_crawler_trigger_arn" {
  description = "ARN of the Lambda function responsible for triggering the Glue Crawler when new CUR data is uploaded into the S3 bucket."
  value       = aws_lambda_function.run_crawler.arn
}

output "lambda_crawler_trigger_role_arn" {
  description = "ARN of the IAM role used by the Lambda function responsible for starting the Glue Crawler."
  value       = aws_iam_role.lambda.arn
}

output "crawler_arn" {
  description = "ARN of the Glue Crawler responsible for populating the Catalog Database with new CUR data."
  value       = aws_lambda_function.run_crawler.arn
}

output "crawler_role_arn" {
  description = "ARN of the IAM role used by the Glue Crawler responsible for populating the Catalog Database with new CUR data."
  value       = aws_iam_role.crawler.arn
}

output "glue_catalog_database_name" {
  description = "Name of the Glue Catalog Database which is populated with CUR data."
  value       = aws_glue_catalog_database.cur.name
}