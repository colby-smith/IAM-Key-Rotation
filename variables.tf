variable "new_key_description" {
  description = "Description for the new access key"
  type        = string
  default     = "New access key"
}

variable "parameter_prefix" {
  description = "Prefix for SSM parameter names"
  type        = string
  default     = "/IAM/Users/"
}
