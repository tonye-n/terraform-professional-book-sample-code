terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
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

resource "time_sleep" "wait" {
  create_duration = "1m"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-terraform-professional"
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-time"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  address_space = ["10.100.0.0/16"]

  depends_on = [
    time_sleep.wait,
  ]
}
