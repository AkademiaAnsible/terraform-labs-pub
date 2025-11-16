resource "azurerm_storage_account" "this" {
  name                     = var.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  #allow_blob_public_access = var.allow_blob_public_access
  min_tls_version          = var.min_tls_version
  tags                     = var.tags
}
