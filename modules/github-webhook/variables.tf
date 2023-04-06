variable "github_repository" {}

variable "events" {
  default = ["push", "pull_request"]
}

variable "github_webhook_secret" {}