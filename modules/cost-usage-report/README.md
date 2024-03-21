# AWS Cost & Usage Reports

This Terraform module stands up a Cost and Usage Report, together with necessary services making the CUR data queryable in Athena.

## Overview

The overall architecture looks like the illustration below
![AWS Cost and Usage Reports overview](./assets/overview.png)

1. AWS delivers Cost and Usage Reports data to the S3 bucket continuously
2. Whenever new CUR data is delivered, a Glue Crawler makes sure the newly available CUR data is processed and made available in the Data Catalog
3. Athena provides an SQL interface to the CUR data, using the Data Catalog as its data source
4. QuickSight visualizes the data returned from querying Athena

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13, < 2.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.cur"></a> [aws.cur](#provider\_aws.cur) | ~> 3.29 |
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.29 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_use_existing_s3_bucket"></a> [use\_existing\_s3\_bucket](#input\_use\_existing\_s3\_bucket) | Whether to use an existing S3 bucket or create a new one. Regardless, `s3_bucket_name` must contain the name of the bucket. | `bool` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket into which CUR will put the cost data. | `string` | n/a | yes |
| <a name="input_s3_use_existing_kms_key"></a> [s3\_use\_existing\_kms\_key](#input\_s3\_use\_existing\_kms\_key) | Whether to use an existing KMS CMK for S3 SSE. | `bool` | n/a | yes |
| <a name="input_s3_kms_key_alias"></a> [s3\_kms\_key\_alias](#input\_s3\_kms\_key\_alias) | Alias for the KMS CMK, existing or otherwise. | `string` | `""` | no |
| <a name="input_report_name"></a> [report\_name](#input\_report\_name) | Name of the Cost and Usage Report which will be created. | `string` | n/a | yes |
| <a name="input_report_frequency"></a> [report\_frequency](#input\_report\_frequency) | How often the Cost and Usage Report will be generated. HOURLY or DAILY. | `string` | n/a | yes |
| <a name="input_report_versioning"></a> [report\_versioning](#input\_report\_versioning) | Whether reports should be overwritten or new ones should be created. | `string` | n/a | yes |
| <a name="input_report_format"></a> [report\_format](#input\_report\_format) | Format for report. Valid values are: textORcsv, Parquet. If Parquet is used, then Compression must also be Parquet. | `string` | n/a | yes |
| <a name="input_report_compression"></a> [report\_compression](#input\_report\_compression) | Compression format for report. Valid values are: GZIP, ZIP, Parquet. If Parquet is used, then format must also be Parquet. | `string` | n/a | yes |
| <a name="input_report_additional_artifacts"></a> [report\_additional\_artifacts](#input\_report\_additional\_artifacts) | A list of additional artifacts. Valid values are: REDSHIFT, QUICKSIGHT, ATHENA. When ATHENA exists within additional\_artifacts, no other artifact type can be declared and report\_versioning must be OVERWRITE\_REPORT. | `set(string)` | n/a | yes |
| <a name="input_s3_bucket_prefix"></a> [s3\_bucket\_prefix](#input\_s3\_bucket\_prefix) | Prefix in the S3 bucket to put reports. | `string` | `""` | no |
| <a name="input_cur_role_arn"></a> [cur\_role\_arn](#input\_cur\_role\_arn) | ARN of the role to assume in order to provision the Cost and Usage Reports S3 bucket in us-east-1. | `string` | `""` | no |
| <a name="input_cur_role_session_name"></a> [cur\_role\_session\_name](#input\_cur\_role\_session\_name) | Session name to use when assuming `cur_role_arn`. | `string` | `""` | no |
| <a name="input_lambda_log_group_retention_days"></a> [lambda\_log\_group\_retention\_days](#input\_lambda\_log\_group\_retention\_days) | Number of days to retain logs from the Lambda function, which ensures Glue Crawler runs when new CUR data is available. | `number` | `14` | no |
| <a name="input_glue_crawler_create_log_group"></a> [glue\_crawler\_create\_log\_group](#input\_glue\_crawler\_create\_log\_group) | Whether to create a CloudWatch Log Group for the Glue Crawler. Crawlers share Log Group, and this gives the option of managing the Log Group with retention through this module. | `bool` | `true` | no |
| <a name="input_glue_crawler_log_group_retention_days"></a> [glue\_crawler\_log\_group\_retention\_days](#input\_glue\_crawler\_log\_group\_retention\_days) | Number of days to retain logs from the Glue Crawler, which populates the Athena table whenever new CUR data is available. | `number` | `14` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags which will be applied to provisioned resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | Name of S3 bucket used for storing CUR data. This may be provisioned by this module or not. |
| <a name="output_s3_bucket_prefix"></a> [s3\_bucket\_prefix](#output\_s3\_bucket\_prefix) | Prefix used for storing CUR data inside the S3 bucket. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of S3 bucket used for storing CUR data. This may be provisioned by this module or not. |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region) | Region where the S3 bucket used for storing CUR data is provisioned. This may be provisioned by this module or not. |
| <a name="output_report_name"></a> [report\_name](#output\_report\_name) | Name of the provisioned Cost and Usage Report. |
| <a name="output_lambda_crawler_trigger_arn"></a> [lambda\_crawler\_trigger\_arn](#output\_lambda\_crawler\_trigger\_arn) | ARN of the Lambda function responsible for triggering the Glue Crawler when new CUR data is uploaded into the S3 bucket. |
| <a name="output_lambda_crawler_trigger_role_arn"></a> [lambda\_crawler\_trigger\_role\_arn](#output\_lambda\_crawler\_trigger\_role\_arn) | ARN of the IAM role used by the Lambda function responsible for starting the Glue Crawler. |
| <a name="output_crawler_arn"></a> [crawler\_arn](#output\_crawler\_arn) | ARN of the Glue Crawler responsible for populating the Catalog Database with new CUR data. |
| <a name="output_crawler_role_arn"></a> [crawler\_role\_arn](#output\_crawler\_role\_arn) | ARN of the IAM role used by the Glue Crawler responsible for populating the Catalog Database with new CUR data. |
| <a name="output_glue_catalog_database_name"></a> [glue\_catalog\_database\_name](#output\_glue\_catalog\_database\_name) | Name of the Glue Catalog Database which is populated with CUR data. |

<!--- END_TF_DOCS --->

## References

It is based on [AWS: Query and Visualize AWS Cost and Usage](https://aws.amazon.com/blogs/big-data/query-and-visualize-aws-cost-and-usage-data-using-amazon-athena-and-amazon-quicksight/).
Check out the blog post and the linked resources for an explanation of the concepts.

For more information about Cost & Usage Reports in general, see [AWS: What are Cost and Usage Reports?](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13, < 2.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.cur"></a> [aws.cur](#provider\_aws.cur) | ~> 3.29 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.29 |
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_use_existing_s3_bucket"></a> [use\_existing\_s3\_bucket](#input\_use\_existing\_s3\_bucket) | Whether to use an existing S3 bucket or create a new one. Regardless, `s3_bucket_name` must contain the name of the bucket. | `bool` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name of the S3 bucket into which CUR will put the cost data. | `string` | n/a | yes |
| <a name="input_s3_use_existing_kms_key"></a> [s3\_use\_existing\_kms\_key](#input\_s3\_use\_existing\_kms\_key) | Whether to use an existing KMS CMK for S3 SSE. | `bool` | n/a | yes |
| <a name="input_s3_kms_key_alias"></a> [s3\_kms\_key\_alias](#input\_s3\_kms\_key\_alias) | Alias for the KMS CMK, existing or otherwise. | `string` | `""` | no |
| <a name="input_report_name"></a> [report\_name](#input\_report\_name) | Name of the Cost and Usage Report which will be created. | `string` | n/a | yes |
| <a name="input_report_frequency"></a> [report\_frequency](#input\_report\_frequency) | How often the Cost and Usage Report will be generated. HOURLY or DAILY. | `string` | n/a | yes |
| <a name="input_report_versioning"></a> [report\_versioning](#input\_report\_versioning) | Whether reports should be overwritten or new ones should be created. | `string` | n/a | yes |
| <a name="input_report_format"></a> [report\_format](#input\_report\_format) | Format for report. Valid values are: textORcsv, Parquet. If Parquet is used, then Compression must also be Parquet. | `string` | n/a | yes |
| <a name="input_report_compression"></a> [report\_compression](#input\_report\_compression) | Compression format for report. Valid values are: GZIP, ZIP, Parquet. If Parquet is used, then format must also be Parquet. | `string` | n/a | yes |
| <a name="input_report_additional_artifacts"></a> [report\_additional\_artifacts](#input\_report\_additional\_artifacts) | A list of additional artifacts. Valid values are: REDSHIFT, QUICKSIGHT, ATHENA. When ATHENA exists within additional\_artifacts, no other artifact type can be declared and report\_versioning must be OVERWRITE\_REPORT. | `set(string)` | n/a | yes |
| <a name="input_s3_bucket_prefix"></a> [s3\_bucket\_prefix](#input\_s3\_bucket\_prefix) | Prefix in the S3 bucket to put reports. | `string` | `""` | no |
| <a name="input_cur_role_arn"></a> [cur\_role\_arn](#input\_cur\_role\_arn) | ARN of the role to assume in order to provision the Cost and Usage Reports S3 bucket in us-east-1. | `string` | `""` | no |
| <a name="input_cur_role_session_name"></a> [cur\_role\_session\_name](#input\_cur\_role\_session\_name) | Session name to use when assuming `cur_role_arn`. | `string` | `null` | no |
| <a name="input_lambda_log_group_retention_days"></a> [lambda\_log\_group\_retention\_days](#input\_lambda\_log\_group\_retention\_days) | Number of days to retain logs from the Lambda function, which ensures Glue Crawler runs when new CUR data is available. | `number` | `14` | no |
| <a name="input_glue_crawler_create_log_group"></a> [glue\_crawler\_create\_log\_group](#input\_glue\_crawler\_create\_log\_group) | Whether to create a CloudWatch Log Group for the Glue Crawler. Crawlers share Log Group, and this gives the option of managing the Log Group with retention through this module. | `bool` | `true` | no |
| <a name="input_glue_crawler_log_group_retention_days"></a> [glue\_crawler\_log\_group\_retention\_days](#input\_glue\_crawler\_log\_group\_retention\_days) | Number of days to retain logs from the Glue Crawler, which populates the Athena table whenever new CUR data is available. | `number` | `14` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags which will be applied to provisioned resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | Name of S3 bucket used for storing CUR data. This may be provisioned by this module or not. |
| <a name="output_s3_bucket_prefix"></a> [s3\_bucket\_prefix](#output\_s3\_bucket\_prefix) | Prefix used for storing CUR data inside the S3 bucket. |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of S3 bucket used for storing CUR data. This may be provisioned by this module or not. |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region) | Region where the S3 bucket used for storing CUR data is provisioned. This may be provisioned by this module or not. |
| <a name="output_report_name"></a> [report\_name](#output\_report\_name) | Name of the provisioned Cost and Usage Report. |
| <a name="output_lambda_crawler_trigger_arn"></a> [lambda\_crawler\_trigger\_arn](#output\_lambda\_crawler\_trigger\_arn) | ARN of the Lambda function responsible for triggering the Glue Crawler when new CUR data is uploaded into the S3 bucket. |
| <a name="output_lambda_crawler_trigger_role_arn"></a> [lambda\_crawler\_trigger\_role\_arn](#output\_lambda\_crawler\_trigger\_role\_arn) | ARN of the IAM role used by the Lambda function responsible for starting the Glue Crawler. |
| <a name="output_crawler_arn"></a> [crawler\_arn](#output\_crawler\_arn) | ARN of the Glue Crawler responsible for populating the Catalog Database with new CUR data. |
| <a name="output_crawler_role_arn"></a> [crawler\_role\_arn](#output\_crawler\_role\_arn) | ARN of the IAM role used by the Glue Crawler responsible for populating the Catalog Database with new CUR data. |
| <a name="output_glue_catalog_database_name"></a> [glue\_catalog\_database\_name](#output\_glue\_catalog\_database\_name) | Name of the Glue Catalog Database which is populated with CUR data. |
<!-- END_TF_DOCS -->