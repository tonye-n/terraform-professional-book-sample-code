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

data "aws_vpc" "this" {
  tags = {
    Name = "my-network"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = data.aws_vpc.this.id
  cidr_block = cidrsubnet(data.aws_vpc.this.cidr_block, 4, 1)

  tags = {
    Name = "Main"
  }
}
