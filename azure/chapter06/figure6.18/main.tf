terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "default" {
  name = "rg-terraform-professional"
}

data "azurerm_virtual_network" "app" {
  name                = "vnet-app"
  resource_group_name = data.azurerm_resource_group.default.name
}

resource "azurerm_subnet" "db" {
  name                 = "snet-database"
  resource_group_name  = data.azurerm_resource_group.default.name
  virtual_network_name = data.azurerm_virtual_network.app.name

  address_prefixes = [
    cidrsubnet(
      data.azurerm_virtual_network.app.address_space[0],
      8,
      12
    )
  ]
}
