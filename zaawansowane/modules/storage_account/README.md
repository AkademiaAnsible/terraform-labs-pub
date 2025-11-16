# Moduł Terraform: Storage Account

Moduł tworzy Storage Account w Azure z podstawową walidacją i parametryzacją.

## Argumenty
- `resource_group_name` — nazwa grupy zasobów (wymagane)
- `location` — region Azure (wymagane)
- `storage_name` — nazwa Storage Account (12-24 znaki, małe litery i cyfry, wymagane)
- `account_tier` — tier konta (Standard/Premium, domyślnie Standard)
- `account_replication_type` — typ replikacji (LRS, GRS, RAGRS, ZRS, domyślnie LRS)
- `allow_blob_public_access` — czy zezwolić na publiczny dostęp do blobów (domyślnie false)
- `min_tls_version` — minimalna wersja TLS (domyślnie TLS1_2)
- `tags` — mapa tagów (opcjonalnie)

## Przykład użycia
```hcl
module "storage" {
  source                  = "./modules/storage_account"
  resource_group_name     = "demo-rg"
  location                = "westeurope"
  storage_name            = "demostorage1234"
  account_tier            = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
  tags = {
    Owner = "terraform"
    Env   = "dev"
  }
}
```

## Outputs
- `storage_account_id` — ID utworzonego Storage Account
- `storage_account_name` — nazwa utworzonego Storage Account
