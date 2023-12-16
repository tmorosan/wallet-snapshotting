variable "bucket" {}
variable "key" {}
variable "region" {}

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
  region = "us-west-1"
  assume_role = {
    role_arn = "arn:aws:iam::249556908394:role/TerraformDeployer"
  }
}


