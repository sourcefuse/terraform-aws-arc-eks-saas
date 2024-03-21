locals {
  lambda_function_name = "${var.report_name}-crawler-trigger"
}

resource "aws_s3_bucket_notification" "cur" {
  bucket = var.s3_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.run_crawler.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "${var.s3_bucket_prefix}/"
    filter_suffix       = ".parquet"
  }

  depends_on = [
    aws_s3_bucket.cur,
    aws_lambda_permission.allow_bucket,
    aws_s3_bucket_policy.cur,
  ]
}

resource "aws_lambda_function" "run_crawler" {
  function_name = local.lambda_function_name

  role = aws_iam_role.lambda.arn

  runtime          = "python3.9"
  handler          = "index.handler"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  timeout          = 30

  environment {
    variables = {
      CRAWLER_NAME = aws_glue_crawler.this.name
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda,
    aws_cloudwatch_log_group.lambda,
  ]
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/src/index.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.run_crawler.arn
  source_account = data.aws_caller_identity.current.account_id
  principal      = "s3.amazonaws.com"
  source_arn     = var.use_existing_s3_bucket ? data.aws_s3_bucket.cur[0].arn : aws_s3_bucket.cur[0].arn
}

resource "aws_iam_role" "lambda" {
  name               = "${var.report_name}-crawler-trigger"
  assume_role_policy = data.aws_iam_policy_document.crawler_trigger_assume.json
}

resource "aws_iam_role_policy" "lambda" {
  role   = aws_iam_role.lambda.name
  policy = data.aws_iam_policy_document.crawler_trigger.json
}

data "aws_iam_policy_document" "crawler_trigger_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "crawler_trigger" {
  statement {
    sid = "CloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
  }

  statement {
    sid = "Glue"

    effect = "Allow"

    actions = [
      "glue:StartCrawler",
    ]

    resources = [aws_glue_crawler.this.arn]
  }
}

# Pre-create log group for the Lambda function.
# Otherwise it will be created by Lambda itself with infinite retention.
#
# Accept default encryption. This Lambda does not produce sensitive logs.
# #tfsec:ignore:AWS089
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.lambda_log_group_retention_days
}