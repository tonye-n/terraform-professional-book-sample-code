variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}


variable "tags" {
  description = "A map of tags to assign to the security group"
  type        = map(string)
}

variable "rules" {
  description = "A list of rules to apply to the security group"
  type = list(object({
    name        = string
    direction   = string
    protocol    = string
    from_port   = number
    to_port     = number
    destination = optional(string)
    source      = optional(string)
  }))
}