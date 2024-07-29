resource "aws_instance" "Ansible-Master" {
  ami                 = "ami-069e932a9ce4cb22f"
  instance_type       = "t2.micro"
  key_name   = "java-spring-boot-proj"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  ebs_block_device {
    device_name = "/dev/sda1"
    snapshot_id = "snap-0a320a1f62b62c40e"
    volume_size = 8
  }

   tags = {
    Name = "Ansible-Master"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0cc788223aeb888b5"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_ssh"
  }
}

resource "aws_instance" "Jenkins" {
  ami                 = "ami-0c2af51e265bd5e0e"
  instance_type       = "t2.medium"
  vpc_security_group_ids = ["sg-0d04836c17c78490b"]
  key_name   = "java-spring-boot-proj"

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
  }

   tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "Nexus" {
  ami                 = "ami-0c2af51e265bd5e0e"
  instance_type       = "t2.medium"
  vpc_security_group_ids = ["sg-0d04836c17c78490b"]
  key_name   = "java-spring-boot-proj"

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
  }
   tags = {
    Name = "Nexus"
  }
}
/*
resource "aws_instance" "Prometheus-Grafana" {
  ami                 = "ami-0c2af51e265bd5e0e"
  instance_type       = "t2.medium"
  vpc_security_group_ids = ["sg-000aef5ffadc0c6e9"]
  key_name   = "java-spring-boot-proj"

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
  }
   tags = {
    Name = "Prometheus & Grafana"
  }
}
*/
