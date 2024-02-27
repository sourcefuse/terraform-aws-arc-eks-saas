region      = "us-east-1"
environment = "dev"
namespace   = "arc-saas"
map_additional_iam_roles = [
    {
      groups    = ["system:nodes", "system:bootstrappers"]
      role_arn  = "arn:aws:iam::471112653618:role/arc-saas-dev-eks-cluster"
      user_name = "system:node:{{EC2PrivateDNSName}}"
    }]
map_additional_iam_users = [
    {
      groups    = "system:masters"
      user_arn  = "arn:aws:iam::471112653618:user/harshit.kumar"
      user_name = "admin"
    },
    {
      groups    = "system:masters"
      user_arn  = "arn:aws:iam::471112653618:user/rahul.sharma"
      user_name = "admin"
    }
  ]