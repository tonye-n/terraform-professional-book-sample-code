variable "name_suffix" {
  type = string

  validation {
    condition     = can(regex("^[a-z]+$", var.name_suffix))
    error_message = "Should only contain lowercase letters"
  }
}
