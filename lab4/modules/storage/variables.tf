variable "resource_group_name" {
  description = "Nazwa grupy zasobów."
  type        = string
}

variable "storage_account_name" {
  description = "Nazwa konta magazynu."
  type        = string
}

variable "location" {
  description = "Region Azure."
  type        = string
}

variable "account_tier" {
  description = "Warstwa wydajności konta magazynu (Standard lub Premium)."
  type        = string
  default     = "Standard"
}
