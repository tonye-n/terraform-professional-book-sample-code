terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }

}

provider "aws" {
  region = "us-west-1"
}

module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

}

resource "aws_subnet" "web" {
 vpc_id = module.network.vpc_id
    cidr_block = cidrsubnet(module.network.vpc_cidr_block, 8, 10)
}

output "vpc" {
  value = {
    id = aws_vpc.this.id
    cidr_block = aws_vpc.this.cidr_block
  }
}