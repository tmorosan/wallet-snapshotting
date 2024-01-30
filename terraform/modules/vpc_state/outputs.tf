output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "private_subnet_cidrs" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_cidrs
}

output "private_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

output "public_subnet_cidrs" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_cidrs
}

output "public_subnet_ids" {
  value = data.terraform_remote_state.vpc.outputs.public_subnet_ids
}


output "default_security_group_id" {
  value = data.terraform_remote_state.vpc.outputs.default_security_group_id
}

output "nat_gateway_ips" {
  value = data.terraform_remote_state.vpc.outputs.nat_gateway_ips
}