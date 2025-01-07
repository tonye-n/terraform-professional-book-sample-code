variable "name_suffix" {
  type = string

  validation {
    condition     = can(regex("^[a-z]+$", var.name_suffix))
    error_message = "Should only contain lowercase letters"
  }

  validation {
    condition     = length(var.name_suffix) == 10
    error_message = "Must be exactly 10 characters long"
  }
}
