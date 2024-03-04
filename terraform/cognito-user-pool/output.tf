output "cognito_domain" {
  value = module.aws_cognito_user_pool.client_ids[0]
}

output "id" {
  value = module.aws_cognito_user_pool.id
}