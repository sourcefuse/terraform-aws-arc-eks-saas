variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  default     = ""
  type        = string
}

variable "add_extra_iam_roles" {
  type = list(object({
    groups    = list(string)
    role_arn  = string
    user_name = string
  }))
  default = []
}

variable "add_extra_iam_users" {
  type = list(object({
    groups    = list(string)
    user_arn  = string
    user_name = string
  }))
  default = []
}

variable "add_extra_aws_accounts" {
  type    = list(string)
  default = []
}