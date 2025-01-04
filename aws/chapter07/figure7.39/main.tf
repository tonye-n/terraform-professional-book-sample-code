terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }

  backend "s3" {
    bucket         = "<REPLACE>"
    key            = "state/teams/team1/terraform.tfstate"
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

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = "<REPLACE>"
    key            = "state/sharing/network/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
  }
}

resource "aws_subnet" "web" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc.id

  cidr_block = cidrsubnet(
    data.terraform_remote_state.vpc.outputs.vpc.cidr_block, 8, 10
  )
}
