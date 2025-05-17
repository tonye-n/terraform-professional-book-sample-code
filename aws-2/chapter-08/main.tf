terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }
  }


}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-${var.environment}"
  }

}

module "web_security_group" {
  source = "./modules/security-group"
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "vpc-${var.environment}"
  }
  rules = [
    {
      name        = "allow_http"
      description = "Allow HTTP traffic"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      source      = "0.0.0.0/0"
      direction   = "in"
    },
    {
      name        = "allow_https"
      description = "Allow HTTPS traffic"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      source      = "0.0.0.0/0"
      direction   = "in"
  }]
}