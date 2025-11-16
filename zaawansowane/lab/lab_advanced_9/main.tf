# Lab Advanced 9: Walidacja i bezpieczeństwo kodu

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Przykład: zasób z potencjalnym błędem bezpieczeństwa
resource "azurerm_storage_account" "bad" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true # celowo niepoprawne
  tags                     = var.tags
}
