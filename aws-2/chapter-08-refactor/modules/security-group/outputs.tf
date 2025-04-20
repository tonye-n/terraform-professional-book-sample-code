output "security_group" {
  value = {
    id = aws_security_group.my_security_group.id

  }
}