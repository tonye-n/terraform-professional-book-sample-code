resource "azurerm_network_security_group" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
}

locals {
  rules = {
    for rule in var.rules : rule.name => rule
  }
}

resource "azurerm_network_security_rule" "all" {
  for_each = local.rules

  network_security_group_name = azurerm_network_security_group.this.name
  resource_group_name         = var.resource_group_name

  name                       = each.key
  access                     = each.value.access
  protocol                   = each.value.protocol
  priority                   = each.value.priority
  direction                  = each.value.direction
  source_address_prefix      = each.value.source_address_prefix
  source_port_range          = each.value.source_port_range
  destination_address_prefix = each.value.destination_address_prefix
  destination_port_range     = each.value.destination_port_range
}
