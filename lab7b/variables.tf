variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "Name of the Resource Group to create (must be globally unique in subscription)."
  type        = string
  default     = "tf-lab7b-rg"
}

variable "virtual_network_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "lab7b-vnet"
}

variable "vnet_address_space" {
  description = "List of CIDR ranges for the VNet address space"
  type        = list(string)
  default     = ["10.70.0.0/16"]
}

# Map of subnets with CIDR and optional service endpoints.
# Each key becomes the subnet name.
variable "subnets" {
  description = "Map defining subnets. Key = subnet name; value contains cidr and optional service_endpoints list."
  type = map(object({
    cidr             = string
    service_endpoints = optional(list(string))
  }))
  default = {
    frontend = {
      cidr = "10.70.1.0/24"
      service_endpoints = ["Microsoft.Storage"]
    }
    backend = {
      cidr = "10.70.2.0/24"
    }
    database = {
      cidr = "10.70.3.0/24"
    }
  }
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Lab         = "7b"
    CreatedBy   = "terraform"
  }
}
