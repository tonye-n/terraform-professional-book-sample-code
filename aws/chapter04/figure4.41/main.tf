terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "all" {
  for_each   = toset(["10.0.0.0/16", "192.168.0.0/16"])
  cidr_block = each.key
}
