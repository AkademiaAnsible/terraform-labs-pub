# Lab Advanced 7: Zmienne, locals, typy danych, tfvars, warunki, datasources

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

locals {
  subnet_count = length(var.subnets)
  subnet_names = [for s in var.subnets : s.name]
  default_tags = merge(var.tags, { Lab = "advanced7" })
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.default_tags
}

resource "azurerm_subnet" "subnet" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.prefix]
}

# Przykład datasources: pobierz info o regionie
data "azurerm_subscription" "current" {}
