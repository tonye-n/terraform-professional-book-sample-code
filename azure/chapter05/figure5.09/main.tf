terraform {
  required_version = ">= 1.6.0"

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

resource "azurerm_storage_account" "backup" {
  name                = "stterraformbackups"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  access_tier              = "Hot"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}
