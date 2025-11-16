# Lab Advanced 6: Zaawansowane moduły — outputs, locals, walidacja

provider "azurerm" {
  features {}
}

module "network" {
  source              = "../../modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  tags                = var.tags
}
