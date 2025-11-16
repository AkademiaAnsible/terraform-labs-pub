variable "resource_group_name" {
  type        = string
  description = "Nazwa grupy zasobów"
}

variable "location" {
  type        = string
  description = "Region Azure"
  default     = "westeurope"
}

variable "storage_name" {
  type        = string
  description = "Nazwa Storage Account"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}
