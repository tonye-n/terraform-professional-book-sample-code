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

variable "location" {
  type    = string
  default = "swedencentral"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-terraform-professional"
  location = var.location
}

resource "azurerm_virtual_network" "app" {
  name                = "vnet-app"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  address_space = ["10.100.0.0/16"]
}
