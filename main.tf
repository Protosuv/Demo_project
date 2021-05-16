# Configure the AWS Provider
provider "aws" {
  region                  = var.aws-region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "default"
}
# We find AMI for Centos 7
  data "aws_ami" "centos" {
    most_recent = true
    owners      = ["aws-marketplace"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["CentOS Linux 7*"]
  }
}

data "aws_caller_identity" "current" {}
# I use module for instance
# module "ec2-instance" {
#   source                 = "terraform-aws-modules/ec2-instance/aws"
#   version                = "~> 2.0"
#   name                   = "Server"
#   instance_count         = 1
#   ami                    = data.aws_ami.centos.id
#   instance_type          = "t2.micro"
#   key_name               = "user1"
#   monitoring             = true
#   vpc_security_group_ids = ["sg-2e81ef1b"]
#   subnet_id              = "subnet-2844c477"

#   tags = {
#     Name = "Server"
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
resource "aws_vpc" "demo-vpc" {
  cidr_block = "172.16.1.0/24"
  
  tags = {
    Name = "VPC"
  }
}
resource "aws_internet_gateway" "demo-gateway" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}
resource "aws_subnet" "demo-subnet" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "172.16.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Subnet"
  }
}
resource "aws_route_table" "demo-route-table" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gateway.id
  }
  tags = {
    Name = "Route Table"
  }
}
resource "aws_route_table_association" "route-table-association-demo" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-route-table.id
}
resource "aws_network_interface" "server" {
  subnet_id   = aws_subnet.demo-subnet.id
  private_ips = ["172.16.1.5"]
  tags = {
    Name = "server_network_interface"
  }
}
resource "aws_network_interface" "client" {
  subnet_id   = aws_subnet.demo-subnet.id
  private_ips = ["172.16.1.100"]
  tags = {
    Name = "client_network_interface"
  }
}
resource "aws_key_pair" "alex" {
  key_name   = "alex-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1fCXdtHHRvcu6GZxyHP4wU99OItkXFb84FDjKzhpH9RdC4ACbOFqv8sp+WIrHv+U5R5s9GEd5B9g9Kin0g3k44OgZpuMuxa5nxLUggK/Qbpgnqpu5T+YzIBytV6fedWIl+YjHYhte5g7wIlM2UmMUltgFai78Lv2I2CENR1zv4JzH5pqnvPOGgxdZDThqIlu9VcjNWUW6Bj1SjHAeQtTu8GFJ0265MdthMy2wFE4Sc8tSh1W9UfsHhl1UxA3G8Z4y1GMRH5/Xw/QfAlnpIAx0dEpkClN9Nrx8pTAsaFT4fwfHAEABXhWVnwvVaN04XqlDusvwngvmoGH+Ee6GqSZqGHXLUzI18GTrBuB6hedfzwOkSlwvGvdP2jaeKXEFHaoOB1px9hlaPfXADiFX6IxsICrZMnC9/Wpc8jk095nqrGRZMlglG7dcQIETcK0SHjCwml2/kQImBhIRwdmm/XAiSqjoyKEOlowH62UtFwOz7wjqYwrRM7bPb4Ji9jtojQz6cksU3rsZwtmv1NSFi9VpoxHalhkYkxtDn6C3pObhR0WkeTyVCvb1jhhsKOopeE2mReStzDgfnZHDd+YAIxGKnq5SbuS3oXyBSyFEm2tnCAzXdKSCLUckXYfXytPo2ZNMHAY9s8rlSkbNrfkFCzP5BkuqeaPhOlxD/DnBrJszaQ== protosuv@gmail.com"
}
resource "aws_instance" "server" {
  ami           = data.aws_ami.centos.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]
  key_name = "alex-key"

  tags = {
    Name = "Server"
  }
  # network_interface {
  #   network_interface_id = aws_network_interface.server.id
  #   device_index         = 0
  # }
  instance_initiated_shutdown_behavior = "stop"
  associate_public_ip_address = "true"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    delete_on_termination = "false"
    volume_size = 8
  }
}

resource "aws_instance" "client" {
  ami           = data.aws_ami.centos.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]
  key_name = "alex-key"
  tags = {
    Name = "Client"
  }
  # network_interface {
  #   network_interface_id = aws_network_interface.client.id
  #   device_index         = 0
  # }
  instance_initiated_shutdown_behavior = "stop"
  associate_public_ip_address = "true"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    delete_on_termination = "false"
    volume_size = 8
  }
}
//
//resource "aws_instance" "fileserver" {
//  ami = data.aws_ami.ubuntu.id
//  instance_type = "t2.micro"
//  tags = {
//    "project": "main"
//  }
//  lifecycle {
//    create_before_destroy = true
//    prevent_destroy = true
//    ignore_changes = [tags]
//  }
//}

