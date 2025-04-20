variable "vpc_id" {
  description = "The ID of the VPC where the resources will be deployed"
  type        = string
  
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  
}

variable "rules" {
  description = "The rules to apply to the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    direction  = string
    name       = string
    source = optional(string)
    destination = optional(string)
  })) 

  
}