locals {
  map_karpenter_iam_role = [
    {
      groups    = ["system:nodes", "system:bootstrappers"]
      role_arn  = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/${data.aws_ssm_parameter.karpenter_role.value}"
      user_name = "system:node:{{EC2PrivateDNSName}}"
    }
  ]
}