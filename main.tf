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
module "ec2-instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"
  name                   = "Server"
  instance_count         = 1
  ami                    = data.aws_ami.centos.id
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-2e81ef1b"]
  subnet_id              = "subnet-2844c477"

  tags = {
    Name = "Server"
    Terraform   = "true"
    Environment = "dev"
  }
}