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