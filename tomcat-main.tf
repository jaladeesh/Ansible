provider "aws" {
  region = "ap-south-1" # Change this to your desired region
  profile = "ec2-access"
}

resource "aws_instance" "Terraform-tomcat" {
  ami           = "ami-0c2af51e265bd5e0e" # Change this to the latest Ubuntu AMI in your region
  instance_type = "t2.micro"
  key_name      = "java-spring-boot-proj" # Change this to your key pair name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y openjdk-11-jdk
              sudo apt install -y tomcat10 tomcat10-admin
              cd /etc/tomcat10/
              sudo sed -i '/<\/tomcat-users>/i <role rolename="admin-gui"/>' /etc/tomcat10/tomcat-users.xml
              sudo sed -i '/<\/tomcat-users>/i <role rolename="manager-gui"/>' /etc/tomcat10/tomcat-users.xml
              sudo sed -i '/<\/tomcat-users>/i <user username="tomcat" password="asdf@123" roles="admin-gui,manager-gui"/>' /etc/tomcat10/tomcat-users.xml

              # Change the port in server.xml
              sudo sed -i "s/8080/8082/" /etc/tomcat10/server.xml

              sudo systemctl restart tomcat10.service
              EOF

  tags = {
    Name = "Terraform-tomcat"
  }
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http_tomcat"
  }
}

output "instance_ip" {
  value = aws_instance.Terraform-tomcat.public_ip
}