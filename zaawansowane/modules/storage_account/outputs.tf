output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "ID utworzonego Storage Account"
}

output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "Nazwa utworzonego Storage Account"
}
