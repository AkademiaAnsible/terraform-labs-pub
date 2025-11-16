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
