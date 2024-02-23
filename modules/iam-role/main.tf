################################################################################
## IAM Role
################################################################################
data "aws_iam_policy_document" "assume_role" {
  count = length(keys(var.principals)) > 0 ? length(keys(var.principals)) : 0
  statement {
    effect  = "Allow"
    actions = var.assume_role_actions

    principals {
      type        = element(keys(var.principals), count.index)
      identifiers = var.principals[element(keys(var.principals), count.index)]
    }

    dynamic "condition" {
      for_each = var.assume_role_conditions
      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

data "aws_iam_policy_document" "assume_role_aggregated" {
  override_policy_documents = data.aws_iam_policy_document.assume_role[*].json
}


resource "aws_iam_role" "default" {
  name                 = var.role_name
  description          = var.role_description
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role_aggregated[*].json)
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary
  path                 = var.path
  tags                 = var.tags
}

data "aws_iam_policy_document" "default" {
  override_policy_documents = var.policy_documents
}

resource "aws_iam_policy" "default" {
  name        = var.policy_name
  description = var.policy_description
  policy      = join("", data.aws_iam_policy_document.default.*.json)
  path        = var.path
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = join("", aws_iam_role.default.*.name)
  policy_arn = join("", aws_iam_policy.default.*.arn)
}
