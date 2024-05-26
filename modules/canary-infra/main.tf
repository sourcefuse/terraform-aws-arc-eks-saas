resource "aws_kms_key" "canaries_reports_bucket_encryption_key" {
  enable_key_rotation = true
}

resource "aws_s3_bucket" "canaries_reports_bucket" {
  bucket = "${var.namespace}-${var.environment}-canaries-reports-bucket-${data.aws_caller_identity.current.account_id}"
  #checkov:skip=CKV_AWS_18:The bucket does not require access logging
  #checkov:skip=CKV_AWS_144:The bucket does not require cross-region replication
  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "canaries_reports_bucket_encryption_configuration" {
  bucket = aws_s3_bucket.canaries_reports_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.canaries_reports_bucket_encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "canaries_reports_bucket_versioning" {
  bucket = aws_s3_bucket.canaries_reports_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "canaries_reports_bucket_lifecycle_configuration" {
  bucket = aws_s3_bucket.canaries_reports_bucket.bucket
  rule {
    id = "config"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    status = "Enabled"
  }
}

# resource "aws_s3_bucket_acl" "canaries_reports_bucket_acl" {
#   bucket = aws_s3_bucket.canaries_reports_bucket.bucket
#   acl    = "private"
# }

resource "aws_s3_bucket_public_access_block" "canaries_reports_bucket_block_public_access" {
  bucket                  = aws_s3_bucket.canaries_reports_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "canaries_reports_bucket-policy" {
  bucket = aws_s3_bucket.canaries_reports_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "CanariesReportsBucketPolicy"
    Statement = [
      {
        Sid    = "Permissions"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Action   = ["s3:*"]
        Resource = ["${aws_s3_bucket.canaries_reports_bucket.arn}/*"]
      },
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Action" : "s3:*",
        "Effect" : "Deny",
        "Resource" : [
          aws_s3_bucket.canaries_reports_bucket.arn,
          "${aws_s3_bucket.canaries_reports_bucket.arn}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        },
        "Principal" : "*"
      }
    ]
  })
}

data "aws_iam_policy_document" "canary-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "canary-role" {
  name               = "canary-role"
  assume_role_policy = data.aws_iam_policy_document.canary-assume-role-policy.json
  description        = "IAM role for AWS Synthetic Monitoring Canaries"

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = aws_iam_role.canary-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy_document" "canary-policy" {
  statement {
    sid    = "CanaryS3Permission1"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = [
      aws_s3_bucket.canaries_reports_bucket.arn,
      "${aws_s3_bucket.canaries_reports_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "CanaryS3Permission2"
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = [
      "arn:aws:s3:::*"
    ]
  }

  statement {
    sid    = "CanaryCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
    ]
  }

  statement {
    sid    = "CanaryCloudWatchAlarm"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      values   = ["CloudWatchSynthetics"]
      variable = "cloudwatch:namespace"
    }
  }

  statement {
    sid    = "CanaryinVPC"
    effect = "Allow"
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeInstances",
      "ec2:AttachNetworkInterface"
    ]
    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:network-interface/*"
    ]
  }
}

resource "aws_iam_policy" "canary-policy" {
  name        = "canary-policy"
  policy      = data.aws_iam_policy_document.canary-policy.json
  description = "IAM role for AWS Synthetic Monitoring Canaries"

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "canary-policy-attachment" {
  role       = aws_iam_role.canary-role.name
  policy_arn = aws_iam_policy.canary-policy.arn
}

resource "aws_security_group" "canary_sg" {
  name        = "canary_security_group"
  description = "Allow canaries to call the services they need to call"
  vpc_id      = var.vpc_id

  #checkov:skip=CKV2_AWS_5:Security group is correctly attached using output variable
  egress = [
    {
      description      = "Allow calls from canary to DNS"
      from_port        = 53
      to_port          = 53
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow calls from canary to HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow calls from canary to HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "TCP"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
  ]

  tags = var.tags
}

resource "aws_security_group" "canary_endpoints_sg" {
  name        = "canary_endpoints_sg"
  description = "Security group attached to interface endpoints"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "Allow calls from canary to HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "TCP"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [aws_security_group.canary_sg.id]
      self             = false
    }
  ]

  tags = var.tags
}