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

  # replace with valid subscription id
  subscription_id = "01b89761-1cb9-444e-9f68-3d4946f7f106"
}

provider "azurerm" {
  features {}
  alias = "prod"

  # replace with valid subscription id
  subscription_id = "1b8e5d86-9bca-4953-99dc-be25c9a945cd"
}

resource "azurerm_resource_group" "network" {
  name     = "rg-networks"
  location = "swedencentral"
}

module "network" {
  source = "./modules/network"

  providers = {
    azurerm.secondary = azurerm.prod
  }

  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
}
