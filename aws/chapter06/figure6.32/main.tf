terraform {
  required_version = ">= 1.6.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

resource "local_file" "config" {
  filename = "config.hcl"
  content = templatefile("config.hcl.tpl", {
    name = "mattias"
    tags = {
      age   = "getting older"
      hobby = "terraform"
    }
  })
}
