
resource "aws_security_group" "this" {
  vpc_id = var.vpc_id
  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "all" {
  for_each = local.ingress_rules
  security_group_id = aws_security_group.this.id
  from_port = each.value.from_port
  to_port = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4 = each.value.source
  
}

resource "aws_vpc_security_group_egress_rule" "all" {
  for_each = local.egress_rules
  security_group_id = aws_security_group.this.id
  from_port = each.value.from_port
  to_port = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4 = each.value.destination
  
}