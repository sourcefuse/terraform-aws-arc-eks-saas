locals {

  new_role_yaml = join("", [
    for role in var.add_extra_iam_roles : <<-EOF
      - groups:
${join("\n", [for group in role.groups : "        - ${group}"])}
        rolearn: ${role.role_arn} 
        username: ${role.user_name}
    EOF
  ])

  new_user_yaml = join("", [
    for user in var.add_extra_iam_users : <<-EOF
      - groups:
${join("\n", [for group in user.groups : "        - ${group}"])}
        userarn: ${user.user_arn}
        username: ${user.user_name}
    EOF
  ])

  new_account_yaml = join("", [
    for acct in var.add_extra_aws_accounts : <<-EOF
${join("\n", [for group in acct.accounts : "        - ${group}"])}
    EOF
  ])
}
