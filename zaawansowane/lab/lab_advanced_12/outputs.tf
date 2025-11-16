output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Nazwa utworzonej grupy zasobów"
}

output "vnet_id" {
  value       = module.network.vnet_id
  description = "ID utworzonego VNet"
}

output "storage_account_id" {
  value       = module.storage.storage_account_id
  description = "ID utworzonego Storage Account"
}

output "key_vault_id" {
  value       = azurerm_key_vault.kv.id
  description = "ID utworzonego Key Vault"
}

output "user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.uai.id
  description = "ID utworzonej User Assigned Identity"
}

output "function_app_name" {
  value       = module.function_app.functionapp_name
  description = "Nazwa Function App"
}

output "function_app_default_hostname" {
  value       = module.function_app.function_app_default_hostname
  description = "Domyślny hostname Function App"
}
