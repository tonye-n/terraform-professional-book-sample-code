terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }

  # Add this block after creating a workspace in HCP Terraform
  # cloud {
  #   organization = "<your HCP Terraform organization name>"

  #   workspaces {
  #     name = "azure-terraform-101"
  #   }
  # }
}
