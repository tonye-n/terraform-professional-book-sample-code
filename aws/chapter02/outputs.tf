output "aws_vpc_id" {
  description = "ID of the AWS VPC"
  value       = aws_vpc.this.id
}

output "aws_subnet_ids" {
  description = "IDs of all subnets in the VPC"
  value       = aws_subnet.all[*].id
}
