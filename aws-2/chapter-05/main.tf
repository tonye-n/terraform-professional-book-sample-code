resource "aws_security_group" "web" {
  description = "Security group for web servers"

  tags = {
    Name = "Web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  description = "Allow HTTPS access from anywhere"
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  description = "Allow SSH access from anywhere"
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

/*
import {
  to = aws_vpc_security_group_ingress_rule.ssh
  id = "sgr-02a46361e5c460a52"
}
*/