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

locals {
  rules = {
    http = {
      name     = "http"
      port     = 80
      priority = 100
    }
    https = {
      name     = "https"
      port     = 443
      priority = 200
    }
  }
}

resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  dynamic "security_rule" {
    for_each = local.rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
