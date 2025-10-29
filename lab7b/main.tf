terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Subnets using for_each over map variable
resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.cidr]

  dynamic "service_endpoints" {
    for_each = try(each.value.service_endpoints, [])
    content {
      service = service_endpoints.value
    }
  }
}

# Outputs
output "vnet_name" {
  description = "Name of the created Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_names" {
  description = "List of subnet names created via for_each"
  value       = [for s in azurerm_subnet.subnets : s.name]
}

output "subnet_id_map" {
  description = "Map of subnet name => subnet id" 
  value       = { for k, s in azurerm_subnet.subnets : k => s.id }
}
