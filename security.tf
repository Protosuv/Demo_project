resource "aws_security_group" "ingress-all-test"  {
    name = "allow-all-sg"
    vpc_id = aws_vpc.demo-vpc.id
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = -1
        to_port = -1
        protocol = "icmp"
      }
   
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 22
        to_port = 22
        protocol = "tcp"
      }
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 2233
        to_port = 2233
        protocol = "tcp"
      }
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 2244
        to_port = 2244
        protocol = "tcp"
      }
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 443
        to_port = 443
        protocol = "tcp"
      }
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 80
        to_port = 80
        protocol = "tcp"
      }
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
      }
      ingress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
      }


  // Terraform removes the default rule
      egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
     }
 }