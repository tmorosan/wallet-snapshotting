locals {
  vpc_env = var.env == "prod" ? "prod" : "dev"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    key = "${local.vpc_env}/vpc.tfstate"
    bucket = "${var.project}-tf-remote-state"
  }
}