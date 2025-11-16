# Lab Advanced 4: Moduł Storage Account i publikacja do rejestru

provider "azurerm" {
  features {}
}

module "storage" {
  source              = "../../modules/storage_account" # ujednolicony path do modułu
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_name        = var.storage_name
  tags                = var.tags
}
