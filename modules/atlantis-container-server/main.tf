# docker = {
    #   source  = "kreuzwerker/docker"
    #   version = "3.0.2"
    # }






resource "null_resource" "start_container" {  

  provisioner "remote-exec" {
    inline = [
      "sudo docker run  -d --name=atlantis -p 4141:4141  runatlantis/atlantis:latest atlantis server "
    ]

    connection {
      type        = "ssh"
    user        = "ubuntu"
    host        = aws_instance.self.public_ip
    private_key = file("${local_file.private_key_pem.filename}")
    timeout     = "2m"
    }
  }
  depends_on = [aws_instance.self]
}


# provider "docker" {
#   host = "tcp://${aws_instance.self.public_ip}:2375/"
  
# }



# resource "docker_container" "atlantis" {
  
#   provider = docker

#   name  = "atlantis"
#   image = "runatlantis/atlantis:latest"
#   command = ["atlantis", "server", "--config", "/home/atlantis/atlantis.yaml"]
#   start = true
#   ports {
#     internal = 4141
#     external = 4141
#   }
#   provisioner "file" {
#     source = "${path.module}/atlantis.yaml"
#     destination = "/home/atlantis"
#   }

#   restart = "always"

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     host        = aws_instance.self.public_ip
#     private_key = file("${local_file.private_key_pem.filename}")
#     timeout     = "2m"
#   }
#   depends_on = [
#     aws_instance.self
#   ]
# }


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