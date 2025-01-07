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

variable "check1" {
  type = bool
}

variable "check2" {
  type = bool
}

resource "azurerm_resource_group" "default" {
  name     = "rg-terraform-professional"
  location = "swedencentral"

  lifecycle {
    precondition {
      condition     = alltrue([var.check1, var.check2])
      error_message = "All checks must be true"
    }
  }
}
