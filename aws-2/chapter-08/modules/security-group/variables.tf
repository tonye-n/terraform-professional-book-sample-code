variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

variable "rules" {
  description = "A list of rules to be added to the security group"
  type        = list(object({
    name        = string
    direction   = string
    protocol = string
    from_port = number
    to_port   = number
    destination = optional(string)
    source      = optional(string)
  }))
}

