provider "github" {
  token =data.aws_ssm_parameter.atlantis_github_token.value
  #oauth_token ="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" # data.aws_ssm_parameter.atlantis_github_token.value
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