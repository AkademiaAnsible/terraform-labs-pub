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

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}
