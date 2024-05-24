region                   = "us-west-2"
environment              = "dev"
namespace                = "sf-arc-saas"
map_additional_iam_roles = []
map_additional_iam_users = [
  {
    groups    = ["system:masters"]
    user_arn  = "arn:aws:iam::471112653618:user/harshit.kumar"
    user_name = "admin"
  }
]
map_aws_accounts = []