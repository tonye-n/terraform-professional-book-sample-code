terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "time_sleep" "wait" {
  create_duration = "1m"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

  depends_on = [
    time_sleep.wait,
  ]
}
