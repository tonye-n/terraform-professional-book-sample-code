resource "aws_security_group" "this" {
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "all" {
  for_each = local.ingress_rules

  security_group_id = aws_security_group.this.id
  ip_protocol       = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4 = can(
    regex("^[0-9./]+$", each.value.source)
  ) ? each.value.source : null
  referenced_security_group_id = can(
    regex("^sg-[a-z0-9]+$", each.value.source)
  ) ? each.value.source : null
}

resource "aws_vpc_security_group_egress_rule" "all" {
  for_each = local.egress_rules

  security_group_id = aws_security_group.this.id
  ip_protocol       = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_ipv4 = can(
    regex("^[0-9./]+$", each.value.destination)
  ) ? each.value.destination : null
  referenced_security_group_id = can(
    regex("^sg-[a-z0-9]+$", each.value.destination)
  ) ? each.value.destination : null
}