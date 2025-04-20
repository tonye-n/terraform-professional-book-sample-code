

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom-vpc"
  }

}

module "web_security_group" {
  source = "./modules/security-group"

  vpc_id = aws_vpc.this.id
  tags = {
    Name = "web"
  }
  rules = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      direction = "in"
      name      = "http"
      source    = "0.0.0.0/0"

    },
    {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      direction = "in"
      name      = "https"
      source    = "0.0.0.0/0"
    }
  ]
}