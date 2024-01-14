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
  cidr = var.vpc_cidr
  resource_prefix = var.project
  availability_zones = var.availability_zones
}

module "lambda" {
  source = "./modules/nodejs-lambda"
  region = var.region
  env = var.env
  security_group_id = module.vpc.default_security_group_id
  subnet_ids = [for subnet in module.vpc.private_subnets : subnet.id]
  resource_prefix = var.project
  lambda_configs = var.lambda_configs
}

module "api" {
  source = "./modules/api"
  env = var.env
  region = var.region
  # change this to list of lambda arns
  lambdas = module.lambda.lambda_arns
}