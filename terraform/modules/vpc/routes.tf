resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.resource_prefix}-public-route-table"
  }
}

resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}


resource "aws_route_table" "private_route" {
  for_each = aws_subnet.private_subnet
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.resource_prefix}-private-route-${each.key}"
  }
}

# NAT gateway routes
resource "aws_route" "nat_route" {
  for_each = aws_nat_gateway.nat_gateway
  route_table_id = aws_route_table.private_route[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = each.value.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_route_association" {
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_route.id
}

# Associate private subnets with private route tables
resource "aws_route_table_association" "private_route_association" {
  for_each = aws_subnet.private_subnet
  subnet_id = each.value.id
  route_table_id = aws_route_table.private_route[each.key].id
}