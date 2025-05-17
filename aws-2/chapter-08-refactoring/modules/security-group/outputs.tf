output "security_group" {
  value = {id = aws_security_group.this.id}
  description = "The ID of the security group"
}