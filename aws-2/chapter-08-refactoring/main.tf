resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

}



# resource "aws_security_group" "web" {
#   vpc_id = aws_vpc.this.id
# }

# resource "aws_vpc_security_group_ingress_rule" "http" {
#   security_group_id = aws_security_group.web.id
#   ip_protocol       = "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_ipv4         = "0.0.0.0/0"
# }

# resource "aws_vpc_security_group_ingress_rule" "https" {
#   security_group_id = aws_security_group.web.id
#   ip_protocol       = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_ipv4         = "0.0.0.0/0"
# }

# resource "aws_vpc_security_group_egress_rule" "database" {
#   security_group_id = aws_security_group.web.id
#   ip_protocol       = "tcp"
#   from_port         = 5432
#   to_port           = 5432
#   cidr_ipv4         = var.vpc_cidr_block
# }

# resource "aws_security_group" "database" {
#   vpc_id = aws_vpc.this.id
# }

# resource "aws_vpc_security_group_ingress_rule" "web" {
#   security_group_id            = aws_security_group.database.id
#   ip_protocol                  = "tcp"
#   from_port                    = 5432
#   to_port                      = 5432
#   referenced_security_group_id = aws_security_group.web.id
# }


module "web" {
  source = "../chapter-08-refactoring/modules/security-group"

  vpc_id = aws_vpc.this.id
  rules = [
    {
      name = "http"
      direction = "in"
      protocol = "tcp"
      from_port = 80
      to_port = 80
      source = "0.0.0.0/0"
    },
    {
      name = "https"
      direction = "in"
      protocol = "tcp"
      from_port = 443
      to_port = 443
      source = "0.0.0.0/0"
    },
    {
      name = "database"
      direction = "out"
      protocol = "tcp"
      from_port = 5432
      to_port = 5432
      destination = var.vpc_cidr_block
    }
  ]
}

module "database" {
  source = "./modules/security-group"

  vpc_id = aws_vpc.this.id
  rules = [
    {
      protocol = "tcp"
      from_port = 5432
      to_port = 5432
      source = module.web.security_group.id
      direction = "in"
      name = "web"
    }
  ]
}

moved {
  from = aws_security_group.web
  to = module.web.aws_security_group.this
}

moved {
  from = aws_security_group.database
  to = module.database.aws_security_group.this
}

moved {
  from = aws_vpc_security_group_ingress_rule.http
  to = module.web.aws_vpc_security_group_ingress_rule.all["http"]
}

moved {
  from = aws_vpc_security_group_ingress_rule.https
  to = module.web.aws_vpc_security_group_ingress_rule.all["https"]
}

moved {
  from = aws_vpc_security_group_egress_rule.database
  to = module.web.aws_vpc_security_group_egress_rule.all["database"]
}
