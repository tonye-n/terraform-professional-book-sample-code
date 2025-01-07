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

variable "num_subnets" {
  type    = number
  default = 3
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

resource "azurerm_subnet" "all" {
  count = var.num_subnets

  name                 = "snet-${count.index}"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.app.name

  address_prefixes = [
    cidrsubnet(var.address_space, 8, count.index)
  ]
}
