variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault (from lab13)"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault (optional, used if ID not provided)"
  default     = ""
}

variable "secret_name" {
  type        = string
  description = "Name of the secret in Key Vault to use as VM password"
}

variable "admin_username" {
  type        = string
  description = "VM admin username"
  default     = "azureuser"
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_B1s"
}
