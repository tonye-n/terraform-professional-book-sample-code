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

locals {
  subnets = {
    "eu-west-1a" = {
      name = "subnet-a"
      cidr = "10.0.0.0/24"
    }
    "eu-west-1b" = {
      name = "subnet-b"
      cidr = "10.0.1.0/24"
    }
    "eu-west-1c" = {
      name = "subnet-c"
      cidr = "10.0.2.0/24"
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "all" {
  for_each          = local.subnets
  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = each.value.cidr

  tags = {
    Name = each.value.name
  }
}
