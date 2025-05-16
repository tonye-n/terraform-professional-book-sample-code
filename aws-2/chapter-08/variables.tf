variable "aws_region" {
    description = "The AWS region to deploy the resources in."
    type        = string
    default     = "us-west-1"
}

variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    type        = string
    default     = "10.0.0.0/16"
}