variable "length" {
  description = "Length of the random string"
  type        = number
  default     = 16
}

variable "upper" {
  description = "Include uppercase letters"
  type        = bool
  default     = false
}

variable "lower" {
  description = "Include lowercase letters"
  type        = bool
  default     = true
}

variable "numeric" {
  description = "Include digits"
  type        = bool
  default     = true
}

variable "special" {
  description = "Include special characters"
  type        = bool
  default     = false
}

variable "prefix" {
  description = "Optional prefix to prepend to the output"
  type        = string
  default     = ""
}
