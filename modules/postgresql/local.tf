locals {
  generate_passwords = length(var.pg_users) > 0 ? true : false
}
