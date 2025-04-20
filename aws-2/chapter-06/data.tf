


data "aws_vpc" "my_vpc" {
  depends_on = [aws_vpc.my_vpc]
  tags = {
    Name = "my_network"
  }

}

data "aws_availability_zones" "available" {
  state = "available"
}