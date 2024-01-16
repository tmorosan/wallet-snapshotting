# Backend
terraform {
  backend "s3" {
    bucket         = var.bucket
    key            = var.key
    region         = var.region
    dynamodb_table = var.dynamodb_table
    assume_role    = {
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
  source             = "./modules/vpc"
  env                = var.env
  region             = var.region
  cidr               = var.vpc_cidr
  resource_prefix    = var.project
  availability_zones = var.availability_zones
}

module "security_group" {
  source  = "./modules/security_groups"
  env     = var.env
  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "dynamodb" {
  source          = "./modules/dynamo"
  env             = var.env
  resource_prefix = var.project
}

module "lambda" {
  source            = "./modules/nodejs-lambda"
  region            = var.region
  env               = var.env
  # allow HTTPS connections
  security_group_id = module.security_group.https_sg_id
  subnet_ids        = [for subnet in module.vpc.private_subnets : subnet.id]
  resource_prefix   = var.project
  lambda_configs    = var.lambda_configs
  lambda_global_env = {
    "COLLECTION_TABLE" = module.dynamodb.dynamodb_table_name,
    "ENV"              = var.env,
    "REGION"           = var.region
  }
}

module "api" {
  source  = "./modules/api"
  env     = var.env
  region  = var.region
  resource_prefix = var.project
  # change this to list of lambda arns
  lambdas = module.lambda.lambda_arns
}