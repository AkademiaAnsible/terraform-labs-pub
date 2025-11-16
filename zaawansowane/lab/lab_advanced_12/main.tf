# Lab Advanced 12: Budowa złożonego środowiska, pipeline, testy, zatwierdzenie

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Network module
module "network" {
  source              = "../../modules/network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = var.vnet_name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  tags                = var.tags
}

# Storage module
module "storage" {
  source              = "../../modules/storage_account"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  storage_name        = var.storage_name
  tags                = var.tags
}

# Key Vault for encryption
resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  rbac_authorization_enabled = true
  tags                       = var.tags
}

# User Assigned Identity
resource "azurerm_user_assigned_identity" "uai" {
  name                = "${var.resource_group_name}-uai"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

# Pobierz klucz dostępu do Storage Account (potrzebny dla Function App)
data "azurerm_storage_account" "storage" {
  name                = module.storage.storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
}

# Function App (Linux)
module "function_app" {
  source                     = "../../modules/function_app"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  function_app_name          = var.function_app_name
  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.storage.primary_access_key
  sku_name                   = var.function_app_sku
  tags                       = var.tags
}
