output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_cidrs" {
  value = module.vpc.private_subnet_cidrs
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_cidrs" {
  value = module.vpc.public_subnet_cidrs
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}


output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "nat_gateway_ips" {
  value = module.vpc.nat_gateway_ips
}