variable "resource_group_name" {
  type        = string
  description = "Nazwa grupy zasobów"
}

variable "location" {
  type        = string
  description = "Region Azure"
  default     = "westeurope"
}

variable "vnet_name" {
  type        = string
  description = "Nazwa VNet"
}

variable "address_space" {
  type        = list(string)
  description = "Adresacja VNet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Adresacje podsieci"
}

variable "storage_name" {
  type        = string
  description = "Nazwa Storage Account"
}

variable "key_vault_name" {
  type        = string
  description = "Nazwa Key Vault"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}

variable "function_app_name" {
  type        = string
  description = "Nazwa Function App"
}

variable "function_app_sku" {
  type        = string
  description = "SKU dla App Service Plan (np. Y1, B1, S1)"
  default     = "Y1"
}
