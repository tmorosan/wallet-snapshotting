resource "aws_vpc" "vpc" {

  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.resource_prefix}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.resource_prefix}-igw"
  }
}

locals {
  private_subnets = { for i, v in var.availability_zones : v => cidrsubnet(var.cidr, 8, i + 128) }
  public_subnets  = { for i, v in var.availability_zones : v => cidrsubnet(var.cidr, 8, i + 1) }
}

resource "aws_subnet" "public_subnet" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each                = local.private_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.resource_prefix}-private-subnet-${each.key}"
  }
}

resource "aws_eip" "nat_eip" {
  for_each   = aws_subnet.public_subnet
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.resource_prefix}-nat-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each      = aws_eip.nat_eip
  allocation_id = each.value.id
  subnet_id     = aws_subnet.public_subnet[each.key].id

  tags = {
    Name = "${var.resource_prefix}-nat-gateway-${each.key}"
  }
}

