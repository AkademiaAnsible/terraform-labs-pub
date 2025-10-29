# Lab 7b: VNet + 3 Subnety z `for_each`

## Cel
Utworzyć jedną sieć wirtualną oraz wiele (3) podsieci korzystając z mapy obiektów i mechanizmu `for_each`, pokazując:
- Modelowanie adresacji poprzez mapy i obiekty.
- Dynamiczne bloki (`dynamic`) dla opcjonalnych właściwości (service endpoints).
- Generowanie agregowanych outputów (lista i mapa).
- Dobre praktyki przy planowaniu przestrzeni adresowej.

## Wymagane pojęcia
`for_each`, typy złożone (`map(object)`), `dynamic` block, outputs, tagowanie.

## Pliki w labie
- `variables.tf` – definicja mapy `subnets` i podstawowych zmiennych (region, RG, adresacja VNet).
- `main.tf` – zasoby: `azurerm_resource_group`, `azurerm_virtual_network`, `azurerm_subnet` (z `for_each`).
- `README.md` – instrukcje i rozszerzenia.

## Kroki
1. `terraform init`
2. `terraform plan` – upewnij się, że 3 subnety zostaną utworzone.
3. `terraform apply` – wdrożenie VNet + subnety.
4. Sprawdź outputy: `subnet_names`, `subnet_id_map`.
5. Dodaj nową podsieć (np. `analytics`) w `subnets` i wykonaj ponownie `plan`/`apply`.

## Przykład zmiennej `subnets`
```hcl
subnets = {
  frontend = { cidr = "10.70.1.0/24" service_endpoints = ["Microsoft.Storage"] }
  backend  = { cidr = "10.70.2.0/24" }
  database = { cidr = "10.70.3.0/24" }
}
```

## Walidacja
- Brak nakładania się zakresów CIDR.
- Poprawne nazwy zasobów w Azure.
- Service endpoint dodany tylko dla `frontend`.

## Rozszerzenia
- Dodaj NSG i przypisz do wybranych subnetów.
- Dodaj `delegation` dla subnetu (np. pod Azure Container Apps).
- Zastąp pojedynczy VNet parametryzacją wielu VNet (mapa + `for_each`).

## Sprzątanie
`terraform destroy`

## Najczęstsze błędy
- Literówki w kluczach mapy (zmiana adresu = wymuszona rekreacja subnetu).
- Użycie `count` zamiast `for_each` – utrata stabilnych adresów przy zmianach.
- Brak planowania przyszłych zakresów – kolizje CIDR.
