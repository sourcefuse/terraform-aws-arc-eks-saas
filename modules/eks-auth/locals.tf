# Define local variable for new role YAML
# locals {
#   new_role_yaml = <<-EOF
#     - groups:
#       - ${var.auth_map_group}
#       rolearn: ${var.aws_iam_role_arn}
#       username: ${var.aws_iam_role_name}
#     EOF
# }

locals {
  new_role_yaml = join("", [
    for role in var.add_extra_iam_roles : <<-EOF
      - groups:
        - ${role.groups}
        rolearn: ${role.role_arn}
        username: ${role.user_name}
    EOF
  ])

  new_user_yaml = join("", [
    for user in var.add_extra_iam_users : <<-EOF
      - groups:
        - ${user.groups}
        userarn: ${user.user_arn}
        username: ${user.user_name}
    EOF
  ])

}
