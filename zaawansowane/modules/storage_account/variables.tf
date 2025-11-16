variable "resource_group_name" {
  type        = string
  description = "Nazwa grupy zasobów"
}

variable "location" {
  type        = string
  description = "Region Azure"
}

variable "storage_name" {
  type        = string
  description = "Nazwa Storage Account"
  validation {
    condition     = length(var.storage_name) >= 12 && length(var.storage_name) <= 24 && can(regex("^[a-z0-9]+$", var.storage_name))
    error_message = "Nazwa Storage Account musi mieć 12-24 znaki, tylko małe litery i cyfry."
  }
}

variable "account_tier" {
  type        = string
  description = "Tier konta (Standard/Premium)"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Typ replikacji (LRS, GRS, RAGRS, ZRS)"
  default     = "LRS"
}

variable "allow_blob_public_access" {
  type        = bool
  description = "Czy zezwolić na publiczny dostęp do blobów?"
  default     = false
}

variable "min_tls_version" {
  type        = string
  description = "Minimalna wersja TLS"
  default     = "TLS1_2"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}
