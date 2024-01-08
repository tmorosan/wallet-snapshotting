variable "region" {
  type = string
  nullable = false
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
    Name = "cc-vpc-${var.env}"
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
    Name = "cc-public-subnet-${var.env}-${element(local.availability_zones, count.index)}"
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
    Name = "cc-private-subnet-${var.env}-${element(local.availability_zones, count.index)}"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "cc-igw-${var.env}"
    Environment = var.env
  }
}

# Best practice is to use a NAT gateway per AZ
# Creates two EIPs for the NAT gateways
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  count = length(var.public_subnets_cidr)
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "cc-nat-eip-${var.env}-${element(local.availability_zones, count.index)}"
    Environment = var.env
  }
}

resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnets_cidr)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)

  tags = {
    Name = "cc-nat-${var.env}-${element(local.availability_zones, count.index)}"
    Environment = var.env
  }
}

# Route tables
# Each NAT gateway needs its own route table, thank you AWS
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.public_subnets_cidr)
  tags = {
    Name = "cc-private-route-${var.env}-${element(local.availability_zones, count.index)}"
    Environment = var.env
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
      Name = "cc-public-route-${var.env}"
      Environment = var.env
  }
}

# Internet gateway route
resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# NAT gateway routes
resource "aws_route" "nat_route" {
  count = length(var.public_subnets_cidr)
  route_table_id = aws_route_table.private_route[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat[count.index].id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_route_association" {
  count = length(var.public_subnets_cidr)
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route.id
}

# Associate private subnets with private route tables
resource "aws_route_table_association" "private_route_association" {
  count = length(var.private_subnets_cidr)
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route[count.index].id
}