terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
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
  name     = "rg-terraform-state-${var.location}"
  location = var.location
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false
}

resource "azurerm_storage_account" "state" {
  name                = "ststate${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  # use globally redundant storage (GRS) to replicate the state file
  # to an additional location
  account_replication_type = "GRS"
  account_tier             = "Standard"
}

resource "azurerm_storage_container" "state" {
  name               = "state"
  storage_account_id = azurerm_storage_account.state.id
}

output "backend" {
  value = <<-EOF
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.default.name}"
    storage_account_name = "${azurerm_storage_account.state.name}"
    container_name       = "${azurerm_storage_container.state.name}"
    key                  = "<REPLACE ME>"
  }
  EOF
}
