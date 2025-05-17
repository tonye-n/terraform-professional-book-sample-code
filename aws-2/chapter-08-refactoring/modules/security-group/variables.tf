variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "rules" {
  description = "List of security group rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    name        = string
    direction = string
    source = optional(string)
    destination = optional(string)
  }))   
  
}