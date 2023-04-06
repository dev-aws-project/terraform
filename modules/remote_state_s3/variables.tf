variable "s3_name" {
  type = string
  default = "yury-aws-project-terraform-remote-state"
}

variable "dynamodb_name" {
  type = string
  default = "terraform-state-lock"
}

