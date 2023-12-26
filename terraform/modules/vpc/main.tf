variable "region" {
  default = "us-west-1"
}
variable "vpc_cidr" {
  type = string
  nullable = false
}
variable "public_subnet_cidr" {
  type = string
  nullable = false
}
variable "private_subnet_cidr" {
  type = string
  nullable = false
}
variable "env" {
  type = string
  nullable = false
}
locals {
  availability_zones = ["${var.region}a", "${var.region}b"]
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