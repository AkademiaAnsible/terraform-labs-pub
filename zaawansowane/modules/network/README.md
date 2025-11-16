# Moduł Terraform: Network (VNet + Subnets)

Moduł tworzy Virtual Network i podsieci w Azure.

## Argumenty
- `resource_group_name` — nazwa grupy zasobów (wymagane)
- `location` — region Azure (wymagane)
- `vnet_name` — nazwa VNet (wymagane)
- `address_space` — lista adresacji VNet (wymagane)
- `subnet_prefixes` — lista adresacji podsieci (wymagane)
- `tags` — mapa tagów (opcjonalnie)

## Przykład użycia
```hcl
module "network" {
  source              = "./modules/network"
  resource_group_name = "demo-rg"
  location            = "westeurope"
  vnet_name           = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24"]
  tags = {
    Owner = "terraform"
  }
}
```

## Outputs
- `vnet_id` — ID utworzonego VNet
- `vnet_name` — nazwa utworzonego VNet
- `subnet_ids` — lista ID utworzonych podsieci
