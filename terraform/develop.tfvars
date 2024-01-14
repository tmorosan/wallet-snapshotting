bucket               = "tmoro-terraform-test"
dynamodb_table       = "tmoro-terraform-test"
key                  = "network/terraform.tfstate"
project              = "tmoro-example"
region               = "us-west-1"
env                  = "develop"
vpc_cidr             = "10.2.0.0/16"

# I'm only using one AZ here because it is a testing env,
# but you can add more if needed
availability_zones = ["us-west-1b"]

lambda_configs = [
  {
    name    = "testResponseLambda"
    memory  = "128"
    timeout = "60"
    runtime = "nodejs18.x"
  },
  {
    name = "testResponseTheSecond"
  },
]
