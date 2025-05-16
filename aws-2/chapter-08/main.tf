resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC"
  }

}

# resource "aws_security_group" "web" {
#   vpc_id = aws_vpc.this.id
#   name    = "web_sg"
#   tags = {
#     Name = "Web Security Group"
#   }

# }

# resource "aws_vpc_security_group_ingress_rule" "http" {
#   security_group_id = aws_security_group.web.id
#   ip_protocol =           "tcp"
#   from_port         = 80
#   to_port           = 80
#   cidr_ipv4 = "0.0.0.0/0"
#     description = "Allow HTTP traffic"

# }

# resource "aws_vpc_security_group_ingress_rule" "https" {
#   security_group_id = aws_security_group.web.id
#   ip_protocol          = "tcp"
#   from_port         = 443
#   to_port           = 443
#   cidr_ipv4 = "0.0.0.0/0"
#     description = "Allow HTTPS traffic"
# }

# resource "aws_vpc_security_group_egress_rule" "database" {
#   security_group_id = aws_security_group.web.id
#   ip_protocol =           "tcp"
#   from_port         = 5432
#   to_port           = 5432

#   cidr_ipv4 = var.vpc_cidr_block
#     description = "Allow database access on port 5432"

# }

# resource "aws_security_group" "database" {
#   vpc_id = aws_vpc.this.id
#   name    = "database_sg"
#   tags = {
#     Name = "Database Security Group"
#   }

# }

# resource "aws_vpc_security_group_ingress_rule" "web" {
#   security_group_id = aws_security_group.database.id
#   ip_protocol =           "tcp"
#   from_port         = 5432
#   to_port           = 5432
#   referenced_security_group_id = aws_security_group.web.id
#     description = "Allow web access on port 5432"

# }



# DATABASE -----------------------------------
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

# WEB ----------------------------------------
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