variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "eu-west-1"

}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}