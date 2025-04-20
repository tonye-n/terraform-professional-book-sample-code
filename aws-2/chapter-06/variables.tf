variable "account_id" {
  type        = string
  description = "AWS Account ID"
  default     = "471112797289"

}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "eu-west-1"

}
variable "allowed_account_ids" {
  type        = list(string)
  description = "List of allowed AWS Account IDs"
  default     = ["471112797289"]
}



