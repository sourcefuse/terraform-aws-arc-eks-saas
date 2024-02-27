variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  default     = ""
  type        = string
}

# variable "auth_map_group" {
#   description = "The IAM group for authentication mapping"
#   default     = ""
# }

# variable "aws_iam_role_arn" {
#   description = "The ARN of the IAM role"
#   default     = ""
# }

# variable "aws_iam_role_name" {
#   description = "The name of the IAM role"
#   default     = ""
# }

variable "add_extra_iam_roles" {
  type = list(object({
    groups    = list(string)
    role_arn  = string
    user_name = string
  }))
  default = []
}