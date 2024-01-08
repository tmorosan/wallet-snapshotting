bucket               = "tmoro-terraform-test"
dynamodb_table       = "tmoro-terraform-test"
key                  = "network/terraform.tfstate"
region               = "us-west-1"
env                  = "develop"
vpc_cidr             = "10.2.0.0/16"
public_subnets_cidr  = ["10.2.0.0/24", "10.2.1.0/24"]
private_subnets_cidr = ["10.2.2.0/24", "10.2.3.0/24"]