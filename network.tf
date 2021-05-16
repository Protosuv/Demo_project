resource "aws_vpc" "demo-vpc" {
  cidr_block = "172.16.1.0/24"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "VPC"
  }
}

resource "aws_eip" "server-ip" {
  instance = aws_instance.server[0].id
  vpc      = true
}
resource "aws_eip" "client-ip" {
  instance = aws_instance.client[0].id
  vpc      = true
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