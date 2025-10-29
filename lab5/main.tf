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

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "storage" {
  source = "./modules/storage"

  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_name = lower("${var.storage_account_prefix}${random_string.suffix.result}")
  location             = var.location
  subnet_id            = azurerm_subnet.default.id
  container_name       = "data"
}

# Po utworzeniu strefy Private DNS przez moduł, zlinkuj ją z VNet
resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "pdz-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = module.storage.private_dns_zone_name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = false
}
