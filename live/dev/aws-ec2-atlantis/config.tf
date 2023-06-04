# terraform {
#   backend "s3" {
#     bucket         = "yury-aws-project-terraform-remote-state"
#     key            = "aws-project/terraform/live/dev/aws-ec2-atlantis.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#   }
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }

    github = {
      source = "integrations/github"
    }

    random = {}

  }
}

