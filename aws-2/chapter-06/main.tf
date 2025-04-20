


resource "time_sleep" "wait" {
  # This resource will wait for a specified duration
  create_duration = "60s"
  # This resource will wait for 60 seconds after the VPC is created
  # before proceeding to the next resource
  # This is useful for ensuring that the VPC is fully provisioned
  # before creating other resources that depend on it
  # such as subnets, security groups, etc.

  depends_on = [aws_vpc.my_vpc]

}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_network"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "all_subnets" {
  # create one subnet for each availability zone in the region
  count = length(data.aws_availability_zones.available.names)

  # use the vpc we created
  vpc_id            = data.aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(data.aws_vpc.my_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_security_group" "web" {
  vpc_id      = data.aws_vpc.my_vpc.id
  name        = "web-sg"
  description = "Allow HTTP and HTTPS traffic"

  dynamic "ingress" {
    for_each = local.ports

    content {
      from_port = ingress.value.port
      to_port   = ingress.value.port
      protocol  = ingress.value.protocol

    }
  }
}

resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-0e42de9d667b232f7" # Replace with the latest Ubuntu AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.all_subnets[0].id


  depends_on = [time_sleep.wait]

  tags = {
    Name = "UbuntuInstance"
  }
}

resource "aws_iam_user" "terraform_user" {
  name = "terraform_user"
  tags = {
    Name = "TerraformUser"
  }
  # This resource creates an IAM user for Terraform
  # with the specified name and tags

}

resource "aws_iam_access_key" "terraform_user_key" {
  user = aws_iam_user.terraform_user.name
  # This resource creates an access key for the IAM user
  # with the specified name
  # This access key can be used to authenticate Terraform


}





