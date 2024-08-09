resource "github_repository" "main" {
  name        = var.name
  description = var.description
  auto_init   = length(var.template.repo) > 0 ? false : var.auto_init

  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  has_issues             = var.has_issues
  has_downloads          = var.has_downloads
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  topics                 = var.topics
  archived               = var.archived
  is_template            = var.is_template
  visibility             = var.visibility

  lifecycle {
    prevent_destroy = true
  }

  dynamic "template" {
    for_each = length(var.template.repo) > 0 ? [var.template.repo] : [] # this makes the template block conditional
    content {
      owner      = var.template.owner
      repository = var.template.repo
    }
  }
}

resource "github_team_repository" "team" {
  for_each   = var.team_access
  repository = github_repository.main.name
  team_id    = each.value.team_id
  permission = each.value.access
}

resource "github_branch_protection_v3" "default" {
  count          = var.branch_protection_enabled ? 1 : 0
  branch         = github_repository.main.default_branch
  repository     = github_repository.main.name
  enforce_admins = var.enforce_admins

  required_status_checks {
    strict = var.require_status_checks
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = var.dismiss_stale_reviews
    require_code_owner_reviews      = var.require_code_owner_reviews
    required_approving_review_count = var.required_approving_review_count
  }
}

resource "github_issue_label" "label" {
  for_each    = var.labels
  name        = each.value.name
  description = each.value.description
  color       = each.value.color_hex
  repository  = github_repository.main.name
}