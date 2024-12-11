terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
}
