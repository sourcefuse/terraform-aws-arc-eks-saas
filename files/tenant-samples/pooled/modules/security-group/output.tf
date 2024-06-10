output "id" {
  value       = aws_security_group.sg[*].id
  description = "The ID of the security group"
}