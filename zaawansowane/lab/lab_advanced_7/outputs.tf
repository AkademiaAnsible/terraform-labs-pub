output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID utworzonego VNet"
}

output "subnet_names" {
  value       = local.subnet_names
  description = "Nazwy utworzonych podsieci (locals)"
}

output "subscription_display_name" {
  value       = data.azurerm_subscription.current.display_name
  description = "Nazwa subskrypcji (datasource)"
}
