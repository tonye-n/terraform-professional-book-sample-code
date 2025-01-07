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

data "azurerm_resource_group" "default" {
  name = "rg-terraform-professional"
}

resource "azurerm_storage_account" "backup" {
  name                     = "stbackup"
  resource_group_name      = data.azurerm_resource_group.default.name
  location                 = data.azurerm_resource_group.default.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  lifecycle {
    # require the resource group to have a "gdpr" tag
    precondition {
      condition = contains(
        keys(data.azurerm_resource_group.default.tags),
        "gdpr"
      )
      error_message = "Resource group should be cleared for GDPR"
    }
  }
}
