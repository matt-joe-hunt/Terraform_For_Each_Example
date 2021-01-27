data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "public-subnet" {
  count = length(data.aws_availability_zones.azs.names)
  cidr_block = "10.0.${1+count.index}.0/24"
  availability_zone = data.aws_availability_zones.azs.names[count.index]
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc-name} Internet Gateway"
  }
}

resource "aws_route_table" "internet-route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.vpc-name} Route Table"
  }
}

resource "aws_main_route_table_association" "route-table-association" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.internet-route.id
}
