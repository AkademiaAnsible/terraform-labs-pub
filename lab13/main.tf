resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  base_name = lower("${var.project}-${var.environment}-${random_string.suffix.result}")
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = coalesce(var.resource_group_name, "${local.base_name}-rg")
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "kv" {
  name                          = replace("${local.base_name}-kv", "-", "")
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = false
  soft_delete_retention_days    = 7
  public_network_access_enabled = true
  rbac_authorization_enabled    = true
  tags                          = var.tags
}

# Nadanie roli na scope Key Vault: Key Vault Secrets Officer
resource "azurerm_role_assignment" "secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = coalesce(var.current_user_object_id, data.azurerm_client_config.current.object_id)
}

output "key_vault_name" {
  value       = azurerm_key_vault.kv.name
  description = "Nazwa Key Vault"
}

output "key_vault_id" {
  value       = azurerm_key_vault.kv.id
  description = "ID Key Vault"
}
