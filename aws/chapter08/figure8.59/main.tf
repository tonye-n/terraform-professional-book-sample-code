resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
}

# DATABASE ---------------------------------------------------------------------
module "database" {
  source = "./modules/security-group"
  vpc_id = aws_vpc.this.id
  rules = [
    {
      name      = "web"
      direction = "in"
      protocol  = "tcp"
      from_port = 5432
      to_port   = 5432
      source    = module.web.security_group.id
    }
  ]
}

moved {
  from = aws_security_group.database
  to   = module.database.aws_security_group.this
}

moved {
  from = aws_vpc_security_group_ingress_rule.web
  to   = module.database.aws_vpc_security_group_ingress_rule.all["web"]
}

data "aws_security_group" "database" {
  id = module.database.security_group.id
}

# WEB --------------------------------------------------------------------------
module "web" {
  source = "./modules/security-group"
  vpc_id = aws_vpc.this.id
  rules = [
    {
      name      = "http"
      direction = "in"
      protocol  = "tcp"
      from_port = 80
      to_port   = 80
      source    = "0.0.0.0/0"
    },
    {
      name      = "https"
      direction = "in"
      protocol  = "tcp"
      from_port = 443
      to_port   = 443
      source    = "0.0.0.0/0"
    },
    {
      name        = "database"
      direction   = "out"
      protocol    = "tcp"
      from_port   = 5432
      to_port     = 5432
      destination = data.aws_security_group.database.id
    }
  ]
}

moved {
  from = aws_security_group.web
  to   = module.web.aws_security_group.this
}

moved {
  from = aws_vpc_security_group_ingress_rule.http
  to   = module.web.aws_vpc_security_group_ingress_rule.all["http"]
}

moved {
  from = aws_vpc_security_group_ingress_rule.https
  to   = module.web.aws_vpc_security_group_ingress_rule.all["https"]
}

moved {
  from = aws_vpc_security_group_egress_rule.database
  to   = module.web.aws_vpc_security_group_egress_rule.all["database"]
}
