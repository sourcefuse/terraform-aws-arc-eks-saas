provider "aws" {
  region = var.region
}

provider "github" {
  token = "${data.aws_ssm_parameter.github_token.value}"
}