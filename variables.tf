variable "user_name" {
  description = "IAM user for which access keys will be rotated"
  type        = string
}

variable "new_key_description" {
  description = "Description for the new access key"
  type        = string
  default     = "New access key"
}

variable "parameter_prefix" {
  description = "Prefix for SSM parameter names"
  type        = string
  default     = "/IAM/users/"
}
