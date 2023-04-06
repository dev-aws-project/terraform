terraform {
  backend "s3" {
    bucket = "yury-aws-project-terraform-remote-state"
    key    = "aws-project/terraform/live/dev/remote_state_s3.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

module "remote_state_s3" {
  source         = "../../../modules/remote_state_s3"
  region         = "us-east-1"
  s3_name        = "yury-aws-project-terraform-remote-state"
  dynamodb_name  = "terraform-state-lock"

}

