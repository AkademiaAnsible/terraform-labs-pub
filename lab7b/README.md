# Lab 7b – Virtual Network z 3 subnetami (for_each)

Cel: Utworzyć VNet i trzy subnety używając konstrukcji `for_each` na mapie zdefiniowanej w zmiennych.

## Pliki
- `main.tf` – zasoby: RG, VNet, Subnety.
- `variables.tf` – definicje zmiennych (adresacja, nazwy, tagi).

## Uruchomienie
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Kluczowe elementy
- `for_each = var.subnets` – tworzy jeden blok `azurerm_subnet` per wpis w mapie.
- Każdy klucz mapy staje się nazwą subnetu (np. `frontend`, `backend`, `database`).
- Dynamiczny blok `service_endpoints` dodawany tylko gdy lista istnieje.

## Modyfikacje
Aby dodać nowy subnet, dopisz wpis do mapy `subnets` w `variables.tf` lub w pliku `.tfvars`, np.:
```hcl
subnets = {
  frontend = { cidr = "10.70.1.0/24" service_endpoints = ["Microsoft.Storage"] }
  backend  = { cidr = "10.70.2.0/24" }
  database = { cidr = "10.70.3.0/24" }
  analytics = { cidr = "10.70.4.0/24" }
}
```

## Outputs
- `vnet_name` – nazwa VNet
- `subnet_names` – lista nazw
- `subnet_id_map` – mapa nazwa => id

## Dobre praktyki
- Unikaj nakładających się zakresów CIDR.
- Ustal konwencję nazewniczą (np. środowisko, projekt, rola).
- Rozważ użycie Azure Verified Modules w większych projektach.

## Sprzątanie
```bash
terraform destroy
```
