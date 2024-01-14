resource "aws_default_security_group" "default_security_group" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.resource_prefix}-default-sg"
  }
}