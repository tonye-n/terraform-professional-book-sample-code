variable "name" {
  description = "Name of the NSG"
  type        = string
}

variable "location" {
  description = "Location of the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "rules" {
  description = "List of security group rules"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_range     = string
  }))
}
