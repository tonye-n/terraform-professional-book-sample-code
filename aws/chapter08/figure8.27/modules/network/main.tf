terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.67.0"
    }
  }
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

output "vpc" {
  value = {
    id         = aws_vpc.this.id
    cidr_block = aws_vpc.this.cidr_block
  }
}
