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

resource "azurerm_resource_group" "default" {
  name     = "rg-modules"
  location = "swedencentral"
}

module "network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.7.1"

  name                = "vnet-app"
  address_space       = ["10.100.100.0/22"]
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}
