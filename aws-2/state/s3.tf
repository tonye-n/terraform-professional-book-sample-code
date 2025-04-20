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
  # The backend configuration is used to store the state file in S3
  backend "s3" {
    bucket         = "terraform-exciting-minnow"
    key            = "state/state-storage-setup/terraform.tfstate"
    region         = "eu-west-1"
    # dynamodb_table = "terrraform-state-locking"
    use_lockfile = true
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

# Create a random pet name for the S3 bucket
resource "random_pet" "bucket" {
  length    = 2
  prefix    = "terraform"
  separator = "-"
}

# Create an S3 bucket for the state file
resource "aws_s3_bucket" "state_storage" {
  bucket        = trimspace(random_pet.bucket.id)
  force_destroy = true
}

# Create a dynamodb table for state locking
# This is used to prevent concurrent operations on the state file
# The table must have a hash key named "LockID" of type String
# The table must have a billing mode of PAY_PER_REQUEST
# The table must have a TTL attribute named "ttl" of type Number
# The table must have a read capacity of 1 and a write capacity of 1
resource "aws_dynamodb_table" "state_locking" {
  name         = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "ttl"
    type = "N"
  }
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "backend" {
  value = <<-EOF
  backend "s3" {
    bucket         = "${aws_s3_bucket.state_storage.bucket}"
    key            = "state/state-storage-setup/terraform.tfstate"
      region         = "${var.aws_region}"
      dynamodb_table = "terrraform-state-locking"
  }
  EOF
}


