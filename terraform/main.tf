variable "key" {}
variable "bucket" {}
variable "env" {}

variable "region" {
  type = string
  nullable = false
}
variable "vpc_cidr" {
  type = string
  nullable = false
}
variable "public_subnets_cidr" {
  type        = list(string)
  nullable    = false
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(string)
  nullable    = false
  description = "CIDR block for Private Subnet"
}
terraform {
  backend "s3" {
    bucket      = var.bucket
    key         = var.key
    region      = var.region
    assume_role = {
      role_arn = "arn:aws:iam::249556908394:role/TerraformDeployer"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  # No credentials explicitly set here because they come from either the
  # environment or the global credentials file.
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  env = var.env
}