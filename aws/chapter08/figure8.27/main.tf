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
  source = "./modules/network"
}

resource "aws_subnet" "web" {
  vpc_id = module.network.vpc.id
  cidr_block = cidrsubnet(
    module.network.vpc.cidr_block, 8, 10
  )
}
