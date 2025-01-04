terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.63.0"
    }
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
}

module "web_security_group" {
  source = "./modules/security-group"

  vpc_id = aws_vpc.this.id
  tags = {
    Name = "web"
  }
  rules = [
    {
      name      = "HTTP"
      direction = "in"
      protocol  = "tcp"
      from_port = 80
      to_port   = 80
      source    = "0.0.0.0/0"
    },
    {
      name      = "HTTPS"
      direction = "in"
      protocol  = "tcp"
      from_port = 443
      to_port   = 443
      source    = "0.0.0.0/0"
    }
  ]
}
