variable "resource_group_name" {
  type        = string
  description = "Nazwa grupy zasobów"
}

variable "location" {
  type        = string
  description = "Region Azure"
  default     = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}

variable "storage_account_name" {
  type        = string
  description = "Nazwa Storage Account dla backendu"
}

variable "container_name" {
  type        = string
  description = "Nazwa kontenera blob dla backendu"
  default     = "tfstate"
}
