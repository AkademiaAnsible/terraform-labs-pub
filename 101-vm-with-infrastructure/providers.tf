terraform {
  required_version = ">=1.12"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>2.7.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}