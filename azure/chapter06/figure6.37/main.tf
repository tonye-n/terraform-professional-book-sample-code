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

variable "address_space" {
  type    = string
  default = "10.100.0.0/16"
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
  name                = "app"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  address_space = [var.address_space]
}

locals {
  subnets = {
    "frontend" = {
      suffix         = "frontend"
      address_prefix = cidrsubnet(var.address_space, 8, 0)
    }
    "backend" = {
      suffix         = "backend"
      address_prefix = cidrsubnet(var.address_space, 8, 1)
    }
    "database" = {
      suffix         = "db"
      address_prefix = cidrsubnet(var.address_space, 8, 2)
    }
  }
}

resource "azurerm_subnet" "all" {
  for_each = local.subnets

  name                 = "snet-${each.value.suffix}"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.app.name

  address_prefixes = [
    each.value.address_prefix
  ]
}
