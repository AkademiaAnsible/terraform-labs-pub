# Moduł Terraform: Function App

Moduł tworzy Azure Function App (Linux) wraz z App Service Plan.

## Argumenty
- `resource_group_name` — nazwa grupy zasobów (wymagane)
- `location` — region Azure (wymagane)
- `function_app_name` — nazwa Function App (wymagane)
- `storage_account_name` — nazwa Storage Account dla Function App (wymagane)
- `storage_account_access_key` — klucz dostępowy do Storage Account (wymagane, sensitive)
- `sku_name` — SKU dla App Service Plan (domyślnie Y1 - Consumption)
- `tags` — mapa tagów (opcjonalnie)

## Przykład użycia
```hcl
module "functionapp" {
  source                      = "./modules/function_app"
  resource_group_name         = "demo-rg"
  location                    = "westeurope"
  function_app_name           = "demo-func-app"
  storage_account_name        = "demostorage1234"
  storage_account_access_key  = "<key>"
  sku_name                    = "Y1"
  tags = {
    Owner = "terraform"
  }
}
```

## Outputs
- `functionapp_id` — ID utworzonej Function App
- `functionapp_name` — nazwa utworzonej Function App
- `function_app_default_hostname` — domyślny hostname Function App
