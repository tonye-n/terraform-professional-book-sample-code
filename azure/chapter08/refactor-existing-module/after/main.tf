resource "azurerm_resource_group" "default" {
  name     = "rg-refactor-to-modules"
  location = var.location
}

resource "azurerm_virtual_network" "app" {
  name                = "vnet-app"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  address_space = [var.virtual_network_address_space]
}

# MODULES --------------------------------------------------------------------------------
module "frontend" {
  source = "./modules/subnet"

  resource_group_location = azurerm_resource_group.default.location
  resource_group_name     = azurerm_resource_group.default.name
  vnet_name               = azurerm_virtual_network.app.name
  subnet_name             = "snet-frontend"
  subnet_address_prefix   = cidrsubnet(var.virtual_network_address_space, 2, 0)
  security_rules = {
    http = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    https = {
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

moved {
  from = azurerm_subnet.frontend
  to   = module.frontend.azurerm_subnet.default
}

moved {
  from = azurerm_network_security_group.frontend
  to   = module.frontend.azurerm_network_security_group.default
}

moved {
  from = azurerm_network_security_rule.http_from_internet
  to   = module.frontend.azurerm_network_security_rule.all["http"]
}

moved {
  from = azurerm_network_security_rule.https_from_internet
  to   = module.frontend.azurerm_network_security_rule.all["https"]
}

moved {
  from = azurerm_subnet_network_security_group_association.frontend
  to   = module.frontend.azurerm_subnet_network_security_group_association.default
}

module "backend" {
  source = "./modules/subnet"

  resource_group_location = azurerm_resource_group.default.location
  resource_group_name     = azurerm_resource_group.default.name
  vnet_name               = azurerm_virtual_network.app.name
  subnet_name             = "snet-backend"
  subnet_address_prefix   = cidrsubnet(var.virtual_network_address_space, 2, 1)
  security_rules = {
    http = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = module.frontend.subnet.address_prefix
      destination_address_prefix = "*"
    }
  }
}

moved {
  from = azurerm_subnet.backend
  to   = module.backend.azurerm_subnet.default
}

moved {
  from = azurerm_network_security_group.backend
  to   = module.backend.azurerm_network_security_group.default
}

moved {
  from = azurerm_network_security_rule.https_from_frontend
  to   = module.backend.azurerm_network_security_rule.all["http"]
}

moved {
  from = azurerm_subnet_network_security_group_association.backend
  to   = module.backend.azurerm_subnet_network_security_group_association.default
}

# BELOW ARE THE COMMENTED OUT RESOURCES THAT WERE MOVED TO MODULES

# FRONTEND -------------------------------------------------------------------------------
# resource "azurerm_subnet" "frontend" {
#   name                 = "snet-frontend"
#   resource_group_name  = azurerm_resource_group.default.name
#   virtual_network_name = azurerm_virtual_network.app.name

#   address_prefixes = [cidrsubnet(var.virtual_network_address_space, 2, 0)]
# }

# resource "azurerm_network_security_group" "frontend" {
#   name                = "nsg-frontend"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
# }

# resource "azurerm_network_security_rule" "http_from_internet" {
#   name                        = "http"
#   resource_group_name         = azurerm_resource_group.default.name
#   network_security_group_name = azurerm_network_security_group.frontend.name

#   priority                   = 100
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source_port_range          = "*"
#   destination_port_range     = "80"
#   source_address_prefix      = "*"
#   destination_address_prefix = "*"
# }

# resource "azurerm_network_security_rule" "https_from_internet" {
#   name                        = "https"
#   resource_group_name         = azurerm_resource_group.default.name
#   network_security_group_name = azurerm_network_security_group.frontend.name

#   priority                   = 200
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source_port_range          = "*"
#   destination_port_range     = "443"
#   source_address_prefix      = "*"
#   destination_address_prefix = "*"
# }

# resource "azurerm_subnet_network_security_group_association" "frontend" {
#   network_security_group_id = azurerm_network_security_group.frontend.id
#   subnet_id                 = azurerm_subnet.frontend.id
# }

# BACKEND -------------------------------------------------------------------------------
# resource "azurerm_subnet" "backend" {
#   name                 = "snet-backend"
#   resource_group_name  = azurerm_resource_group.default.name
#   virtual_network_name = azurerm_virtual_network.app.name

#   address_prefixes = [cidrsubnet(var.virtual_network_address_space, 2, 1)]
# }

# resource "azurerm_network_security_group" "backend" {
#   name                = "nsg-backend"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
# }

# resource "azurerm_network_security_rule" "https_from_frontend" {
#   name                        = "http"
#   resource_group_name         = azurerm_resource_group.default.name
#   network_security_group_name = azurerm_network_security_group.backend.name

#   priority                   = 100
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source_port_range          = "*"
#   destination_port_range     = "443"
#   source_address_prefix      = azurerm_subnet.frontend.address_prefixes[0]
#   destination_address_prefix = "*"
# }

# resource "azurerm_subnet_network_security_group_association" "backend" {
#   network_security_group_id = azurerm_network_security_group.backend.id
#   subnet_id                 = azurerm_subnet.backend.id
# }
