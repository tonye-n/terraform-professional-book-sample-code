terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }
  }

  required_version = ">= 1.6.0"

  cloud {

    organization = "tform-aws-bootcamp"

    workspaces {
      name = "hashicat-aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  /*
  assume_role {
    role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/hashicat-aws"
  }
  */
}