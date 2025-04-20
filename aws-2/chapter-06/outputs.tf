output "my_network_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id


}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = aws_subnet.all_subnets[*].id

}

