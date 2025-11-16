module "storage" {
  source                  = "../../"
  resource_group_name     = "example-rg"
  location                = "westeurope"
  storage_name            = "examplestoracc01"
  account_tier            = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
  tags = {
    Owner = "terraform"
    Env   = "test"
  }
}
