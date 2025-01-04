variable "vpc_id" {
  type = string
}

variable "rules" {
  type = list(object({
    name        = string
    direction   = string
    protocol    = string
    from_port   = number
    to_port     = number
    source      = optional(string)
    destination = optional(string)
  }))
}
