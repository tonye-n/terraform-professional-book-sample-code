terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.62.0"
    }
  }

  # Uncomment for HCP Terraform usage
  # cloud {
  #   organization = "<your organization>"
  #   workspaces {
  #     name = "aws-networking"
  #   }
  # }
}
