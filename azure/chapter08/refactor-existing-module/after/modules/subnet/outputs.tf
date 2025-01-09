output "subnet" {
  value = {
    id             = azurerm_subnet.default.id
    name           = azurerm_subnet.default.name
    address_prefix = azurerm_subnet.default.address_prefixes[0]
  }
}
