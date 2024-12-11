terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }

  backend "s3" {
    bucket         = "<REPLACE>"
    key            = "state/sharing/network/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
  }
}

variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-${var.aws_region}"
  }
}

output "vpc" {
  value = {
    id         = aws_vpc.this.id
    cidr_block = aws_vpc.this.cidr_block
  }
}
