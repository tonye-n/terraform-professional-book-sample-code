terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

  backend "s3" {
    bucket         = "<REPLACE>"
    key            = "<REPLACE>"
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

resource "random_pet" "bucket" {
  prefix = "terraform"
  length = 2
}

resource "aws_s3_bucket" "state_storage" {
  bucket = random_pet.bucket.id
}

resource "aws_dynamodb_table" "state_locking" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "backend" {
  value = <<-EOF
backend "s3" {
  bucket         = "${aws_s3_bucket.state_storage.bucket}"
  key            = "<REPLACE ME>"
  region         = "${var.aws_region}"
  dynamodb_table = "${aws_dynamodb_table.state_locking.name}"
}
EOF
}
