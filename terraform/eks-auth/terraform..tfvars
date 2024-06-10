region                   = "us-east-1"
environment              = ""
namespace                = ""
map_additional_iam_roles = []
map_additional_iam_users = [
  {
    groups    = ["system:masters"]
    user_arn  = "arn:aws:iam::xxxx:user/xxxx" // replace user IAM ARN
    user_name = "admin"
  }
]
map_aws_accounts = []