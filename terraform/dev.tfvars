bucket = "tmoro-terraform-test"
key    = "network/terraform.tfstate"
region = "us-west-1"
env = "develop"
vpc_cidr = "10.0.0.0/16"
public_subnets_cidr = ["10.0.0.0/20", "10.0.128.0/20"]
private_subnets_cidr = ["10.0.16.0/20", "10.0.144.0/20"]