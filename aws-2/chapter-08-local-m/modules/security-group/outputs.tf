output "security_group" {
  description = "The ID of the security group"
  value = { 
    id = aws_security_group.this.id
    }
  }