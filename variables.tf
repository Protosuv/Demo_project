variable "aws-region" {
  default = "us-east-1"
  description = "Default Amazon region"
}
variable "aws-av-zone" {
  default = "us-east-1a"
  description = "Avaliability zone"
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
