resource "azurerm_storage_account" "sa" {
  count                           = 2
  name                            = lower("${var.random_postfix_z_rg}${count.index}")
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false
}