variable "resource_group_name" {
  type        = string
  description = "Nazwa grupy zasobów"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.resource_group_name))
    error_message = "Nazwa grupy zasobów może zawierać tylko litery, cyfry i myślniki."
  }
}

variable "location" {
  type        = string
  description = "Region Azure"
  default     = "westeurope"
}

variable "storage_name" {
  type        = string
  description = "Nazwa Storage Account"
  validation {
    condition     = length(var.storage_name) >= 12 && length(var.storage_name) <= 24 && can(regex("^[a-z0-9]+$", var.storage_name))
    error_message = "Nazwa Storage Account musi mieć 12-24 znaki, tylko małe litery i cyfry."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów (wymagany tag Owner)"
  default     = {}
  validation {
    condition     = contains(keys(var.tags), "Owner")
    error_message = "Tag 'Owner' jest wymagany."
  }
}

variable "exclude_public_access" {
  type        = bool
  description = "Czy wykluczyć publiczny dostęp do Storage Account (mechanizm exclude)?"
  default     = true
}
