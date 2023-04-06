
module "atlantis" {
  source         = "../../../modules/atlantis-aws-ec2"
  ami_id         = "ami-0557a15b87f6559cf"
  instance_type  = "t2.micro"
  public_key     = data.aws_ssm_parameter.atlantis_public_key.value
  private_key    = data.aws_ssm_parameter.atlantis_private_key.value
  root_disk_size = 10
  # github_token   =  data.aws_ssm_parameter.github_token
  github_webhook_secret = data.aws_ssm_parameter.github_webhook_secret.value
  github_repository =  "https://github.com/yuryMarket/aws-project"  

 # depends_on = [data.aws_ssm_parameter.atlantis_public_key, data.aws_ssm_parameter.atlantis_private_key]

}

data "aws_ssm_parameter" "atlantis_public_key" {
  name = "atlantis-ec2-publick-key"

}

data "aws_ssm_parameter" "atlantis_private_key" {
  name = "atlantis-ec2-private-key"

}

data "aws_ssm_parameter" "github_token" {
  name = "atlantis-github-token"
}

data "aws_ssm_parameter" "github_webhook_secret" {
  name = "github-webhook-atlantis-secret"
}


output "atlantis_URL" {
  value = module.atlantis.atlantis_url
}

output "atlantis_host_dns" {
  value = module.atlantis.atlantis_host_dns
}