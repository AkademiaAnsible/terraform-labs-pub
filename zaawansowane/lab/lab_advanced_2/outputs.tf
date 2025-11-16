output "storage_account_names" {
  value       = [for sa in azurerm_storage_account.sa : sa.name]
  description = "Nazwy utworzonych Storage Account"
}

output "nsg_id" {
  value       = azurerm_network_security_group.nsg.id
  description = "ID utworzonego NSG"
}
