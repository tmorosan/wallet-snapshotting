# Backend
terraform {
  backend "s3" {
    bucket      = var.bucket
    key         = var.key
    region      = var.region
    dynamodb_table = var.dynamodb_table
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

# Modules
module "vpc" {
  source = "./modules/vpc"
  env = var.env
  region = var.region
  vpc_cidr = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
}

module "lambda" {
  source = "./modules/lambda"
  bucket = var.bucket
  region = var.region
  env = var.env
  lambdas = var.lambdas
}

module "api" {
  source = "./modules/api"
  env = var.env
  region = var.region
  vpc_arn = module.vpc.arn
  # change this to list of lambda arns
  lambdas = module.lambda.lambdas
}