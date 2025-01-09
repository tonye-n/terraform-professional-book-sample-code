resource "azurerm_resource_group" "default" {
  name     = "rg-terraform-101"
  location = var.location

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-terraform-101"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  address_space = [var.address_space]

  tags = {
    ManagedBy = "Terraform"
  }
}

# BEFORE REFACTORING -----------------------------------------------------------
resource "azurerm_subnet" "frontend" {
  name                 = "snet-frontend"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name

  address_prefixes = [cidrsubnet(var.address_space, 2, 0)]
}

resource "azurerm_subnet" "backend" {
  name                 = "snet-backend"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name

  address_prefixes = [cidrsubnet(var.address_space, 2, 1)]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name

  address_prefixes = [cidrsubnet(var.address_space, 2, 2)]
}

# AFTER REFACTORING ------------------------------------------------------------
# locals {
#   subnets = {
#     frontend = {
#       name = "snet-frontend"
#       cidr = cidrsubnet(var.address_space, 2, 0)
#     },
#     backend = {
#       name = "snet-backend"
#       cidr = cidrsubnet(var.address_space, 2, 1)
#     },
#     db = {
#       name = "snet-db"
#       cidr = cidrsubnet(var.address_space, 2, 2)
#     }
#   }
# }

# moved {
#   from = azurerm_subnet.frontend
#   to   = azurerm_subnet.all["frontend"]
# }

# moved {
#   from = azurerm_subnet.backend
#   to   = azurerm_subnet.all["backend"]
# }

# moved {
#   from = azurerm_subnet.db
#   to   = azurerm_subnet.all["db"]
# }

# resource "azurerm_subnet" "all" {
#   for_each = local.subnets

#   name                 = each.value.name
#   resource_group_name  = azurerm_resource_group.default.name
#   virtual_network_name = azurerm_virtual_network.default.name
#   address_prefixes     = [each.value.cidr]
# }
