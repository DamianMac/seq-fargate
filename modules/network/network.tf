resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = var.tag
  }
}

resource "aws_internet_gateway" "main-internet-gw" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route_table" "main-external" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-internet-gw.id
  }
}


resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.az1

  tags = {
    Name = "main_subnet1"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az2

  tags = {
    Name = "main_subnet2"
  }
}


resource "aws_route_table_association" "external-main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main-external.id
}

resource "aws_route_table_association" "external-secondary" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.main-external.id
}


