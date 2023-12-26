variable "key" {}
variable "bucket" {}
#variable "env" {}

variable "region" {
  default = "us-west-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}
variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}
locals {
  availability_zones = ["${var.region}a", "${var.region}b"]
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
  assume_role = {
    role_arn = "arn:aws:iam::249556908394:role/TerraformDeployer"
  }
}

module "vpc" {
  source = "modules/vpc"
}