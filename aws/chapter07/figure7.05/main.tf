terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.5"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.5"
    }
  }
}
