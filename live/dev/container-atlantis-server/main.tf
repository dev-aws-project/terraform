provider "github" {
  token = data.aws_ssm_parameter.github_token.value
  #oauth_token = data.aws_ssm_parameter.atlantis_github_token.value
  owner = "dev-aws-project"
}



module "github_webhook" {
  source = "../../../modules/github-webhook"  
  github_repository = var.github_repository
  events     = ["push", "pull_request"]  
  github_webhook_secret    = data.aws_ssm_parameter.github_webhook_secret.value
}



data "aws_ssm_parameter" "github_token" {
  name = "atlantis-github-token"
}

data "aws_ssm_parameter" "github_webhook_secret" {
  name = "github-webhook-atlantis-secret"
}