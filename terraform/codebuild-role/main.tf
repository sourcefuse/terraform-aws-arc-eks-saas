##############################################################
## tags
##############################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.5"

  environment = var.environment
  project     = var.namespace

}

##############################################################
## codebuild iam role
##############################################################
module "codebuild_role" {
  source           = "../../modules/iam-role"
  role_name        = "${var.namespace}-${var.environment}-codebuild-iam-role"
  role_description = "CodebuildIAMRole"
  principals = {
    "AWS" = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
  }
  policy_documents = [
    join("", data.aws_iam_policy_document.codebuild_policy.*.json)
  ]
  policy_name        = "${var.namespace}-${var.environment}-codebuild-iam-policy"
  policy_description = "CodebuildIAMPolicy"
  tags               = module.tags.tags
}


##############################################################
## store codebuild role in SSM
##############################################################
module "codebuild_role_ssm_parameters" {
  source = "../../modules/ssm-parameter"
  ssm_parameters = [
    {
      name        = "/${var.namespace}/${var.environment}/codebuild_role"
      value       = module.codebuild_role.arn
      type        = "String"
      overwrite   = "true"
      description = "Codebuild IAM Role"
    }
  ]
  tags = module.tags.tags
}
