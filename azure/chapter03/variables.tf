variable "location" {
  type        = string
  description = "Azure location name"
  default     = "westeurope"
}

variable "address_space" {
  type        = string
  description = "Virtual network address space"
  default     = "10.100.100.0/22"
}
