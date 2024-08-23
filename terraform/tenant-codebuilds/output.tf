output "github_repository_name" {
    value = "${module.saas_management_github_repository.github_repository_name}"
    description = "Github Repository Name"
}

output "github_repository_html_url" {
    value = "${module.saas_management_github_repository.github_repository_html_url}"
    description = "URL to the repository on the web"
}

output "github_repository_ssh_url" {
    value = "${module.saas_management_github_repository.github_repository_ssh_url}"
    description = "URL that can be provided to git clone to clone the repository via SSH."
}

output "github_repository_http_clone_url" {
    value = "${module.saas_management_github_repository.github_repository_http_clone_url}"
    description = "URL that can be provided to git clone to clone the repository via HTTPS."
}

output "github_repository_git_clone_url" {
    value = "${module.saas_management_github_repository.github_repository_git_clone_url}"
    description = "URL that can be provided to git clone to clone the repository anonymously via the git protocol."
}

output "github_repository_repo_id" {
    value = "${module.saas_management_github_repository.github_repository_repo_id}"
    description = "GitHub ID for the repository"
}