variable "aws-region" {
  default = "us-east-1"
  description = "Default Amazon region"
}

locals {
web_instance_type_map = {
  default = "t2.micro"
  }
web_instance_count_map = {
  default = 1
  }
instances = {
  "t2.micro" = data.aws_ami.centos.id
  }
}
