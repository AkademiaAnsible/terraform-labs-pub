# Rozdział 7: Zmienne, locals, typy danych, złożone struktury, tfvars, warunki, datasources

## Cel rozdziału
- Poznasz zaawansowane typy zmiennych i struktur danych w Terraform.
- Nauczysz się korzystać z locals, plików tfvars, warunków i datasources.
- Zrozumiesz, jak budować elastyczne i czytelne konfiguracje.

## Typy kolekcji
| Typ | Użycie | Uwagi |
|-----|--------|-------|
| list(T) | Kolejność ma znaczenie | Można konwertować do set |
| set(T) | Unikalne, bez kolejności | Dobre jako for_each klucze |
| map(T) | Klucze → wartości | Stabilne adresowanie |
| object({...}) | Struktura rekordowa | Waliduje kształt danych |
| tuple([...]) | Heterogeniczna lista | Rzadziej używane |

## Złożone zmienne – przykład
```hcl
variable "subnets" {
	type = map(object({
		cidr                = string
		service_endpoints   = list(string)
		allow_private_links = bool
	}))
}
```

## Locals vs Variables
Variables – interfejs zewnętrzny. Locals – pochodne wartości (nie eksportuj locals jako output bez potrzeby).

## Warunki i funkcje
```hcl
resource "azurerm_storage_account" "sa" {
	name                     = var.name
	account_replication_type = var.is_prod ? "GRS" : "LRS"
	min_tls_version          = coalesce(var.min_tls_version, "TLS1_2")
}
```
`try(expr, fallback)` – obsługa potencjalnych błędów.

## Datasources – kiedy stosować?
Gdy zasób zarządzany poza aktualnym modułem / reusable resolution. Unikaj w modułach ogólnych nadmiernych lookupów – preferuj parametryzację.

Przykład Key Vault zewnętrzny:
```hcl
data "azurerm_key_vault" "shared" {
	name                = var.shared_kv_name
	resource_group_name = var.shared_kv_rg
}
```

## Ćwiczenie
1. Dodaj subnety z listą service endpoints.
2. W local zbuduj listę nazw subnetów.
3. Użyj `for` expression do mapy: `{ for k, v in var.subnets : k => v.cidr }`.

## Pułapki
- Nadmierne datasources → trudniejsza reprodukowalność.
- Null vs brak wartości – explicit defaults.
- Dynamiczne generowanie kluczy for_each z nieznanych danych → błąd plan.

## Dobre praktyki
- Każda zmienna: typ + description.
- Brak wartości domyślnej dla krytycznych danych (wymusza świadome podanie).
- Stosuj map(object) zamiast wielu równoległych list (synchronizacja trudniejsza).

## Efekt końcowy
- Umiejętność modelowania danych wejściowych modulów.

## Następny krok
Integracja CI/CD (`Rozdział 8`).

## Zakres tematyczny
- Typy zmiennych: string, number, bool, list, map, object, tuple.
- Locals — agregacja i przetwarzanie danych.
- Pliki tfvars — zarządzanie konfiguracją środowiskową.
- Warunki (conditional expressions), null, coalesce, try.
- Datasources — pobieranie danych o istniejących zasobach.
- Przykłady złożonych struktur i ich zastosowań.

## Wskazówki
- Stosuj locals do wyliczeń i uproszczenia kodu.
- Pliki tfvars pozwalają łatwo zmieniać konfigurację dla różnych środowisk.
- Warunki i funkcje try/coalesce pomagają obsłużyć opcjonalne wartości.
- Datasources umożliwiają dynamiczne pobieranie danych z chmury.

## Efekt końcowy
- Umiejętność pracy z zaawansowanymi typami i strukturami danych.
- Elastyczne, czytelne i łatwe w utrzymaniu konfiguracje Terraform.
- Gotowość do budowy uniwersalnych i skalowalnych rozwiązań.
