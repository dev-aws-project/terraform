terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }
       
    github = {
      source = "integrations/github"
    }
  }
}


resource "github_repository_webhook" "github_webhook" {
  repository = "terraform"
  events     = var.events 
  active     = true
  configuration {
    url          = "http://${data.terraform_remote_state.aws_ec2_atlantis.outputs.atlantis_host_dns}:4141"
    content_type = "json"
    secret     = var.github_webhook_secret
  }
  
}

data "terraform_remote_state" "aws_ec2_atlantis" {
  backend = "s3"  
  config = {
    bucket = "yury-aws-project-terraform-remote-state"
    key = "aws-project/terraform/live/dev/aws-ec2-atlantis.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
   }
  
  }
