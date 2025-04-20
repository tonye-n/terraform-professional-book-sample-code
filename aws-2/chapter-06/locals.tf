/*
locals {
  ports = [
    80,
    443,
    8080
  ]
  tags = {
    Name        = "web-server"
    Environment = "dev"}
    }
    */

locals {
  ports = {
    http = {
      port     = 80
      protocol = "tcp"
    }
    https = {
      port     = 443
      protocol = "tcp"
    }
  }
}