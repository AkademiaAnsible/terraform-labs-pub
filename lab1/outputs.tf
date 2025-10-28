output "resource_group_name" {
  description = "Nazwa utworzonej grupy zasobów."
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Lokalizacja grupy zasobów."
  value       = azurerm_resource_group.rg.location
}

output "storage_account_name" {
  description = "Nazwa utworzonego konta magazynu."
  value       = azurerm_storage_account.sa.name
}

output "storage_account_primary_blob_endpoint" {
  description = "Główny punkt końcowy blob dla konta magazynu."
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "storage_account_primary_web_endpoint" {
  description = "Główny punkt końcowy web dla konta magazynu (jeśli włączone static websites)."
  value       = azurerm_storage_account.sa.primary_web_endpoint
}

output "storage_container_name" {
  description = "Nazwa utworzonego kontenera w Storage Account."
  value       = azurerm_storage_container.naszstate.name
}
