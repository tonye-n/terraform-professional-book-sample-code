locals {
  ingress_rules = {
    for rule in var.rules : rule.name => rule if rule.direction == "in"
  }
  egress_rules = {
    for rule in var.rules : rule.name => rule if rule.direction == "out"
  }
}

