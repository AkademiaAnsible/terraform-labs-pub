output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Nazwa grupy zasobów"
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID Virtual Network"
}

output "storage_account_name" {
  value       = azurerm_storage_account.storage.name
  description = "Nazwa Storage Account"
}

output "storage_primary_blob_endpoint" {
  value       = azurerm_storage_account.storage.primary_blob_endpoint
  description = "Blob endpoint (private gdy PE włączony)"
}

output "logic_app_name" {
  value       = azurerm_logic_app_standard.logic.name
  description = "Nazwa Logic App"
}

output "logic_app_default_hostname" {
  value       = azurerm_logic_app_standard.logic.default_hostname
  description = "Domyślny hostname Logic App"
}

output "logic_app_identity_principal_id" {
  value       = azurerm_logic_app_standard.logic.identity[0].principal_id
  description = "Principal ID Managed Identity Logic App"
}

output "private_endpoint_blob_ip" {
  value       = var.enable_private_endpoint ? azurerm_private_endpoint.blob[0].private_service_connection[0].private_ip_address : null
  description = "Prywatny IP Private Endpoint (blob)"
}

output "subnet_logic_id" {
  value       = azurerm_subnet.logic.id
  description = "ID subnetu Logic App VNet Integration"
}

output "subnet_pe_id" {
  value       = azurerm_subnet.pe.id
  description = "ID subnetu Private Endpoints"
}
