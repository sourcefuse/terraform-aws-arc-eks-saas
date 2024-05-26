output "reports-bucket" {
  value = aws_s3_bucket.canaries_reports_bucket.id
}

output "security_group_id" {
  value = aws_security_group.canary_sg.id
}

output "role" {
  value = aws_iam_role.canary-role.arn
}