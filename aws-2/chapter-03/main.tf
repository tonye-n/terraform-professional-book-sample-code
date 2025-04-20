resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "vpc-${var.aws_region}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "all" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}
