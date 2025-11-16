output "storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "Nazwa Storage Account dla backendu"
}

output "container_name" {
  value       = azurerm_storage_container.tfstate.name
  description = "Nazwa kontenera blob dla backendu"
}
