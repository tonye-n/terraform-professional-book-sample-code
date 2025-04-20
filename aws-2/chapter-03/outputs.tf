output "aws_vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "aws_subnet_ids" {
  description = "The IDs of the subnets"
  value       = aws_subnet.all[*].id
}