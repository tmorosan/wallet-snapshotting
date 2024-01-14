output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_cidrs" {
  value = local.private_subnets
}

output "public_subnet_cidrs" {
  value = local.public_subnets
}

output "default_security_group_id" {
  value = aws_default_security_group.default_security_group.id
}

output "nat_gateway_ips" {
  value = [ for v in aws_eip.nat_eip: v.public_ip ]
}

output "private_subnets" {
  value = [ for k, v in aws_subnet.private_subnet: {
    az: v.availability_zone
    id: v.id,
    cidr: v.cidr_block
  }]
}

output "public_subnets" {
  value = [ for k, v in aws_subnet.public_subnet: {
    az: v.availability_zone
    id: v.id,
    cidr: v.cidr_block
  }]
}