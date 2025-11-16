variable "project" {
  type        = string
  description = "Nazwa projektu (prefiks)"
}

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

variable "storage_accounts" {
  type = map(object({
    name = string
  }))
  description = "Mapa Storage Account do utworzenia (przykład for_each)"
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "Lista reguł NSG (przykład dynamic block)"
  default     = []
}
