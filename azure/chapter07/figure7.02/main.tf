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

module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "5.0.1"

  resource_group_name = azurerm_resource_group.default.name
  vnet_location       = azurerm_resource_group.default.location
}
