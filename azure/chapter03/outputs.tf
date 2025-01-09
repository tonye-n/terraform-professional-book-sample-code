output "resource_group" {
  value = {
    id   = azurerm_resource_group.default.id
    name = azurerm_resource_group.default.name
  }
}

output "virtual_network" {
  value = {
    id   = azurerm_virtual_network.default.id
    name = azurerm_virtual_network.default.name
  }
}

output "subnets" {
  value = {
    frontend = {
      id             = azurerm_subnet.all["frontend"].id
      address_prefix = azurerm_subnet.all["frontend"].address_prefixes[0]
    }
    backend = {
      id             = azurerm_subnet.all["backend"].id
      address_prefix = azurerm_subnet.all["backend"].address_prefixes[0]
    }
    db = {
      id             = azurerm_subnet.all["db"].id
      address_prefix = azurerm_subnet.all["db"].address_prefixes[0]
    }
  }
}
