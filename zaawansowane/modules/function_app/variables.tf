variable "resource_group_name" {
  type        = string
  description = "Nazwa grupy zasobów"
}

variable "location" {
  type        = string
  description = "Region Azure"
}

variable "function_app_name" {
  type        = string
  description = "Nazwa Function App"
}

variable "storage_account_name" {
  type        = string
  description = "Nazwa Storage Account dla Function App"
}

variable "storage_account_access_key" {
  type        = string
  description = "Klucz dostępowy do Storage Account"
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "SKU dla App Service Plan (np. Y1, B1, S1)"
  default     = "Y1"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}
