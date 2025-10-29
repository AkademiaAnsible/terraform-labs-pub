terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "storage_env" {
  source   = "./modules/storage"
  for_each = var.environments

  resource_group_name  = each.value.resource_group_name
  storage_account_name = each.value.storage_account_name
  location             = var.location
  account_tier         = each.value.account_tier
}
