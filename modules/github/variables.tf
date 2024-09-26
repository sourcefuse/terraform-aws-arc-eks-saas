# GitHub Repository Settings
variable "name" {
  type        = string
  description = "Name of the repository. Can only contain lowercase letters, numbers, and hyphens"

  validation {
    condition     = can(regex("^[a-z0-9-]*$", var.name))
    error_message = "Repository must be named in lowercase, using a-z, 0-9, and - (hyphen) symbols only."
  }
}

variable "description" {
  type        = string
  default     = ""
  description = "(Optional) Repository description. Leave blank for default of: Development repository"
}

variable "homepage_url" {
  default     = ""
  description = "(Optional) Home page URL for the Git repo"
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "(Optional) Visibility of the repository. Can be public, private or internal"

  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Must be one of public, private or internal."
  }
}

variable "has_issues" {
  type        = bool
  default     = true
  description = "(Optional) Enables GitHub issues"
}

variable "has_downloads" {
  type        = bool
  default     = false
  description = "(Optional) Enables GitHub issues"
}

variable "has_projects" {
  type        = bool
  default     = false
  description = "(Optional) Enables GitHub projects"
}

variable "has_wiki" {
  type        = bool
  default     = false
  description = "(Optional) Enables GitHub wiki"
}

variable "is_template" {
  type        = bool
  default     = false
  description = "(Optional) Tells GitHub it's a template repository"
}

variable "delete_branch_on_merge" {
  type        = bool
  default     = true
  description = "(Optional) Automatically delete head branch after a pull request is merged"
}

variable "allow_merge_commit" {
  type        = bool
  default     = false
  description = "(Optional) Set to `false` to disable merge commits on the repository"
}

variable "allow_squash_merge" {
  type        = bool
  default     = true
  description = "(Optional) Set to `false` to disable squash merges on the repository"
}

variable "allow_rebase_merge" {
  type        = bool
  default     = true
  description = "(Optional) Set to `false` to disable rebase merges on the repository"
}

variable "auto_init" {
  type        = bool
  default     = true
  description = "(Optional) Meaningful only during create, set to true to produce an initial commit in the repository"
}

variable "archived" {
  type        = bool
  default     = false
  description = "(Optional) Archives the repository if set to true"
}

variable "topics" {
  type = list(string)
  default = [
    "govuk",
    "hacktoberfest",
  ]
  description = "(Optional) A list of GitHub topics to add to this repository"
}

variable "labels" {
  type = map(object({
    name        = string
    description = string
    color_hex   = string
  }))
  default = {
    # invalid = {
    #   name        = "invalid"
    #   description = ""
    #   color_hex   = "000000"
    # }
  }
  description = "(Optional) A map of labels to add to this repository"
}

variable "template" {
  type = object({
    owner = string
    repo  = string
  })
  default = {
    owner = ""
    repo  = ""
  }
  description = "(Optional) Use a template repository to create this repository"
}

variable "team_access" {
  type = map(object({
    team_id = string
    access  = string
  }))
  default     = {}
  description = "A map of access to the repository"
}

# Github Branch Protection
variable "branch_protection_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Control branch protection for the default branch"
}

variable "enforce_admins" {
  type        = bool
  default     = true
  description = "(Optional) Enforce status checks for repository administrators"
}

variable "require_status_checks" {
  type        = bool
  default     = true
  description = "(Optional) Require all status checks listed in status_checks to pass"
}

variable "status_checks" {
  type        = list(any)
  default     = []
  description = "(Optional) A list of required passing CI checks"
}

# Pull Request Reviews
variable "dismiss_stale_reviews" {
  type        = bool
  default     = true
  description = "(Optional) Dismiss approved reviews automatically when a new commit is pushed"
}

variable "require_code_owner_reviews" {
  type        = bool
  default     = false
  description = "(Optional) Require an approved review in pull requests including files with a designated code owner"
}

variable "required_approving_review_count" {
  type        = number
  default     = 1
  description = "(Optional) Require x number of approvals to satisfy branch protection requirements. If this is specified it must be a number between 1-6"
}