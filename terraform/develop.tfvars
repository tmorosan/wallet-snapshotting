bucket               = "tmoro-terraform-test"
dynamodb_table       = "tmoro-terraform-test"
key                  = "network/terraform.tfstate"
region               = "us-west-1"
# only variables above this line are used when running terraform init
# which means we need to comment below variables out
# this is stupid and there should be a better way
env                  = "develop"
vpc_cidr             = "10.2.0.0/16"
public_subnets_cidr  = ["10.2.0.0/24", "10.2.1.0/24"]
private_subnets_cidr = ["10.2.2.0/24", "10.2.3.0/24"]