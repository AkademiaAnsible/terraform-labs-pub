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

variable "subnets" {
  type = list(object({
    name   = string
    prefix = string
  }))
  description = "Lista podsieci (złożona struktura)"
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}
