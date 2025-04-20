
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.63.0"
    }
  }

  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "terraform-exciting-minnow"
    key            = "chapter-08/state/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locking"
    # use_lockfile = true
  }
}