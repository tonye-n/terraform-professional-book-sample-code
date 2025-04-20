variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "rules" {
  type = list(object({
    name        = string
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    source      = optional(string)
    destination = optional(string)
  }))
  description = "List of security group rules"

}