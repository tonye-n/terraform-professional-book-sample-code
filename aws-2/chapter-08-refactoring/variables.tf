variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "eu-west-1"
}
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
