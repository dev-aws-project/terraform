terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.59.0"
    }
       
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host     = "ssh://ubuntu@${data.terraform_remote_state.aws_ec2_atlantis.outputs.atlantis_host_dns}:22"
  #key_material = base64encode(file("${path.module}/../atlantis-aws-ec2/${data.terraform_remote_state.aws_ec2_atlantis.outputs.host_private_key_name}"))
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "${file("${path.module}/../atlantis-aws-ec2/${data.terraform_remote_state.aws_ec2_atlantis.outputs.host_private_key_name}")}"]
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


# resource "null_resource" "start_container" {  

#   provisioner "remote-exec" {
#     inline = [
#       "sudo docker run  -d --name=atlantis -p 4141:4141  runatlantis/atlantis:latest atlantis server "
#     ]

#     connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     host        = data.terraform_remote_state.aws_ec2_atlantis.outputs.atlantis_host_dns
#     private_key = file("../atlantis-aws-ec2/${local_file.private_key_pem.filename}")
#     timeout     = "2m"
#     }
#   }
# }

resource "docker_container" "atlantis" {
  
  provider = docker

  name  = "atlantis"
  image = "runatlantis/atlantis:latest"
  command = ["atlantis", "server", "--config", "/home/atlantis/atlantis.yaml"]
  start = true
  ports {
    internal = 4141
    external = 4141
  }
  provisioner "file" {
    source = "${path.module}/../atlantis-aws-ec2/atlantis.yaml"
    destination = "/home/atlantis"
  }

  restart = "always"

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = data.terraform_remote_state.aws_ec2_atlantis.outputs.atlantis_host_dns
    private_key = file("${path.module}/../atlantis-aws-ec2/${data.terraform_remote_state.aws_ec2_atlantis.outputs.host_private_key_name}")
    timeout     = "2m"
  }
}

# resource "null_resource" "change_dir_owner"{
#  provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       host        = aws_instance.self.public_ip
#       private_key = file("${local_file.private_key_pem.filename}")
#       timeout     = "2m"

#     }
#       inline = [
#         "sudo  chown ubuntu: /etc && cd /etc && mkdir atlantis"
#       ]
#   }
# }


# resource "null_resource" "create_atlantis_config"{
#   provisioner "file" {
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       host        = aws_instance.self.public_ip
#       private_key = file("${local_file.private_key_pem.filename}")
#       timeout     = "2m"

#     }
#       source      = "${path.module}/atlantis.yaml" # Path to configuration file in the same directory as main.tf file.  
#       destination = "/etc/atlantis/atlantis.yaml"  # Destination path inside the instance where the configuration file will be copied to.  
#   }
# }

# resource "null_resource" "start_atlantis"{
#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       host        = aws_instance.self.public_ip
#       private_key = file("${local_file.private_key_pem.filename}")
#       timeout     = "2m"

#     }
#       inline = [
#         "sudo apt-get update -y && sudo apt-get install -y docker.io && sudo docker run  -d --name=atlantis -p 4141:4141 -v /etc/atlantis:/home/atlantis runatlantis/atlantis:latest atlantis server --config /home/atlantis/atlantis.yaml" # Start the Docker container with our configuration file as an argument.  
#       ]
#   }
# }