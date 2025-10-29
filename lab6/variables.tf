variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "project_name" {
  description = "Name prefix for resources"
  type        = string
  default     = "tf-lab6"
}

variable "resource_group_name" {
  description = "Resource group name. If empty and import_existing_rg_name is set, RG will be data-sourced; otherwise created."
  type        = string
  default     = ""
}

variable "import_existing_rg_name" {
  description = "Name of an existing resource group to be imported or referenced (optional)."
  type        = string
  default     = ""
}

variable "security_rules" {
  description = "Optional NSG rules list"
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    destination_port_range       = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  default = []
}
