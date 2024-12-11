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

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }
}
