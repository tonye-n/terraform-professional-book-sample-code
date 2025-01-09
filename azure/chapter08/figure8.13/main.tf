terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.14.0"
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
  name     = "rg-terraform-local-module"
  location = var.location
}

module "frontend" {
  source = "./modules/nsg"

  name                = "frontend"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name

  rules = [
    {
      name                       = "http"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "80"
    },
    {
      name                       = "https"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
  ]
}

module "db" {
  source = "./modules/nsg"

  name                = "db"
  location            = var.location
  resource_group_name = azurerm_resource_group.default.name

  rules = [
    {
      name                       = "sql"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "10.100.100.0/24"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "1433"
    }
  ]
}
