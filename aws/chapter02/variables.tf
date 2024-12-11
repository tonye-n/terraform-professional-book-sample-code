variable "aws_region" {
  type        = string
  description = "AWS region name"
  default     = "eu-west-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC network"
  default     = "10.0.0.0/16"
}
