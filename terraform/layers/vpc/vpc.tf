module "vpc" {
  source = "../../modules/vpc"
  availability_zones = var.availability_zones
  cidr = var.cidr
  resource_prefix = "${var.env}-${var.project}"
}