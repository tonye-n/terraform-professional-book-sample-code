terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
cloud {

    organization = "tform-aws-bootcamp"

    workspaces {
      name = "hashicat-aws"
    }
  } 


}



provider "aws" {
  region = var.aws_region
}




