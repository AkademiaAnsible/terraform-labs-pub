variable "location" {
  description = "Główny region Azure."
  type        = string
  default     = "West Europe"
}

variable "environments" {
  description = "Mapa środowisk do wdrożenia."
  type = map(object({
    resource_group_name  = string
    storage_account_name = string
    account_tier         = string
  }))
  default = {
    dev = {
      resource_group_name  = "tf-lab4-dev-rg"
      storage_account_name = "tflab4devsa"
      account_tier         = "Standard"
    }
    prod = {
      resource_group_name  = "tf-lab4-prod-rg"
      storage_account_name = "tflab4prodsa"
      account_tier         = "Premium"
    }
  }
}
