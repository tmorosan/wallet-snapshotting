variable "region" {
  default = "us-west-1"
}
variable "vpc_cidr" {
  type = string
  nullable = false
}
variable "public_subnets_cidr" {
  type = list(string)
  nullable = false
}
variable "private_subnets_cidr" {
  type = list(string)
  nullable = false
}
variable "env" {
  type = string
  nullable = false
}
locals {
  availability_zones = ["${var.region}b", "${var.region}c"]
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tmoro-vpc-${var.env}"
    Environment = var.env
  }
}

# Creates two public subnets with different availability zones
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  count = length(var.public_subnets_cidr)
  cidr_block = element(var.public_subnets_cidr, count.index)
  availability_zone = element(local.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "tmoro-public-subnet-${var.env}-${element(local.availability_zones, count.index)}"
    Environment = var.env
  }
}

# Creates two private subnets with different availability zones
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.private_subnets_cidr)
  cidr_block = element(var.private_subnets_cidr, count.index)
  availability_zone = element(local.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "tmoro-private-subnet-${var.env}-${element(local.availability_zones, count.index)}"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "tmoro-igw-${var.env}"
    Environment = var.env
  }
}

# Best practice dictates that you should have a NAT Gateway per AZ
# We only have one NAT gateway here for simplicity
# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "tmoro-nat-eip-${var.env}"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name = "tmoro-nat-${var.env}"
    Environment = var.env
  }
}

# Route tables
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tmoro-private-route-${var.env}"
    Environment = var.env
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
      Name = "tmoro-public-route-${var.env}"
      Environment = var.env
  }
}

# Internet gateway route
resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# NAT gateway route
resource "aws_route" "nat_route" {
  route_table_id = aws_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_route_association" {
  count = length(var.public_subnets_cidr)
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_route_association" {
  count = length(var.private_subnets_cidr)
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route.id
}