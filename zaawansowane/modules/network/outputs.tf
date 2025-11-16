output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "ID utworzonego VNet"
}

output "vnet_name" {
  value       = azurerm_virtual_network.this.name
  description = "Nazwa utworzonego VNet"
}

output "subnet_ids" {
  value       = azurerm_subnet.this[*].id
  description = "Lista ID utworzonych podsieci"
}
