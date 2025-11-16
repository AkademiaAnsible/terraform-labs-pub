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
  default     = "vnet-logicapp"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Adresacja VNet"
  default     = ["10.30.0.0/16"]
}

variable "subnet_logic_prefix" {
  type        = string
  description = "Prefix dla subnetu Logic App VNet Integration"
  default     = "10.30.1.0/24"
}

variable "subnet_pe_prefix" {
  type        = string
  description = "Prefix dla subnetu Private Endpoints"
  default     = "10.30.2.0/24"
}

variable "subnet_other_prefix" {
  type        = string
  description = "Prefix dla innych zasobów"
  default     = "10.30.3.0/24"
}

variable "storage_name" {
  type        = string
  description = "Nazwa Storage Account (globalnie unikalna)"
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_name))
    error_message = "Storage name must be 3-24 lowercase alphanumeric characters"
  }
}

variable "app_service_plan_name" {
  type        = string
  description = "Nazwa App Service Plan"
  default     = "asp-logicapp"
}

variable "app_service_plan_sku" {
  type        = string
  description = "SKU dla App Service Plan (WS1, WS2, WS3 dla Logic App Standard)"
  default     = "WS1"
  validation {
    condition     = contains(["WS1", "WS2", "WS3"], var.app_service_plan_sku)
    error_message = "SKU must be WS1, WS2, or WS3 for Logic App Standard"
  }
}

variable "logic_app_name" {
  type        = string
  description = "Nazwa Logic App"
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Czy włączyć Private Endpoint dla Storage"
  default     = true
}

variable "enable_vnet_integration" {
  type        = bool
  description = "Czy włączyć VNet Integration dla Logic App"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tagi dla zasobów"
  default     = {}
}
