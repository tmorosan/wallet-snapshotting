resource "aws_security_group" "https" {
  vpc_id = var.vpc_id
  description = "Allow HTTPS Egress"
  name = "${var.env}-${var.project}-https-sg"
  egress {
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    protocol = "tcp"
  }
  tags = {
    Name = "${var.env}-${var.project}-https-sg"
  }
}