terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.14.0"

      configuration_aliases = [
        azurerm.secondary
      ]
    }
  }
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

resource "azurerm_virtual_network" "primary" {
  name                = "vnet-primary"
  resource_group_name = var.resource_group_name
  location            = var.location

  address_space = ["10.100.0.0/16"]
}

resource "azurerm_virtual_network" "secondary" {
  provider = azurerm.secondary

  name                = "vnet-secondary"
  resource_group_name = var.resource_group_name
  location            = var.location

  address_space = ["10.200.0.0/16"]
}
