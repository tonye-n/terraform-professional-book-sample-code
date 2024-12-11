terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.60.0"
      configuration_aliases = [
        aws.secondary
      ]
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "that" {
  provider   = aws.secondary
  cidr_block = "192.168.0.0/16"
}
