terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

resource "aws_vpc" "eu" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "us" {
  provider   = aws.us
  cidr_block = "192.168.0.0/16"
}
