# Rozdział 10: Standardy organizacyjne, validate na zasobach, hardenowanie, exclude

## Cel rozdziału
- Poznasz sposoby egzekwowania standardów organizacyjnych w kodzie Terraform.
- Nauczysz się stosować validate na zasobach, hardenować moduły i wykluczać niepożądane wartości.
- Zrozumiesz, jak budować bezpieczne i zgodne z politykami moduły.

## Zakres tematyczny
- Standardy organizacyjne: naming, tagging, polityki bezpieczeństwa.
- Blok validate w zmiennych — wymuszanie wartości, constraints.
- Hardenowanie modułów: blokowanie niepożądanych wartości (np. account key w Storage).
- Mechanizmy exclude — jak umożliwić wyjątki i dokumentować odstępstwa.
- Przykłady wdrożeń w dużych organizacjach.
- Dokumentacja i komunikacja standardów.

## Wskazówki
- Stosuj validate w zmiennych do wymuszania standardów.
- Dokumentuj wyjątki i powody ich zastosowania.
- Hardenowanie kodu zwiększa bezpieczeństwo i zgodność.
- Współpracuj z zespołem ds. bezpieczeństwa przy wdrażaniu polityk.

## Efekt końcowy
- Umiejętność budowy i egzekwowania standardów organizacyjnych.
- Bezpieczne, zgodne z politykami moduły i konfiguracje.
- Gotowość do pracy w środowiskach korporacyjnych.

## Standardy organizacyjne – przykłady
| Obszar | Reguła |
|--------|-------|
| Naming | rg-<proj>-<env>, st<proj><env> ograniczenie długości |
| Tagging | Wymagane: Environment, Project, Owner, CostCenter |
| Bezpieczeństwo | Wymuszone TLS, brak plaintext secrets w output |
| Monitoring | Każdy krytyczny zasób ma Diagnostic Settings |

## Validate w zmiennych – przykład z wykluczeniem
```hcl
variable "storage_replication" {
	type = string
	validation {
		condition     = contains(["LRS","GRS","ZRS"], var.storage_replication)
		error_message = "Replication must be one of LRS|GRS|ZRS"
	}
}
```

## Hardenowanie modułu – przykład parametru blokującego niepożądane wartości
```hcl
variable "allow_access_key_output" {
	type    = bool
	default = false
}

resource "azurerm_storage_account" "secure" { /* ... */ }

output "access_key" {
	value       = azurerm_storage_account.secure.primary_access_key
	description = "Access key (avoid exposing)"
	sensitive   = true
	condition   = var.allow_access_key_output  # pseudo – można warunkowo zorganizować przez oddzielny moduł
}
```
(Warunkowe outputy wymagają często podejścia przez moduł składany.)

## Wyjątki (exclude) – proces
1. Dokumentacja powodu (ticket ID).
2. Tymczasowe dopuszczenie (np. tag `Exception=true`).
3. Review co sprint.

## Mechanizm audytu
Automatyczny raport zasobów z `Exception=true` – skrypt lub narzędzie policy.

## Ćwiczenie
Dodaj walidację środowiska i spróbuj podać wartość `stage` – sprawdź komunikat.

## Efekt końcowy
- Spójne standardy + kontrolowany model wyjątków.

## Następny krok
Narzędzia rozszerzające (Terragrunt/Terramate) (`Rozdział 11`).
