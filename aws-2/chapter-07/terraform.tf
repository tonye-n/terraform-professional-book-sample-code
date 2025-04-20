terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.64.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-exciting-minnow"
    key            = "chapter-07/state/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locking"
    # use_lockfile = true
  }

  required_version = ">= 1.0"
}
