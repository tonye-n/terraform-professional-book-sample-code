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

variable "check1" {
  type = bool
}

variable "check2" {
  type = bool
}

resource "aws_security_group" "web" {
  lifecycle {
    precondition {
      condition     = alltrue([var.check1, var.check2])
      error_message = "All checks must be true"
    }
  }
}
