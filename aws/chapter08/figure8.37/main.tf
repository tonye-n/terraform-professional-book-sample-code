resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
}

# WEB SECURITY GROUP -----------------------------------------------------------
resource "aws_security_group" "web" {
  vpc_id = aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.web.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "database" {
  security_group_id = aws_security_group.web.id
  ip_protocol       = "tcp"
  from_port         = 5432
  to_port           = 5432
  cidr_ipv4         = var.vpc_cidr_block
}

# DATABASE SECURITY GROUP ------------------------------------------------------
resource "aws_security_group" "database" {
  vpc_id = aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "web" {
  security_group_id            = aws_security_group.database.id
  ip_protocol                  = "tcp"
  from_port                    = 5432
  to_port                      = 5432
  referenced_security_group_id = aws_security_group.web.id
}
