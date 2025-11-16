# Rozdział 6: Pogłębienie pracy z modułami

## Cel rozdziału
- Poznasz zaawansowane techniki budowy i testowania modułów Terraform.
- Nauczysz się stosować outputs, locals, warunki i walidacje w modułach.
- Zrozumiesz, jak testować i rozwijać moduły w zespole.

## Locals – wzorzec agregacji
```hcl
locals {
	name_prefix = "${var.project}-${var.environment}"  # jednolite nazwy
	common_tags = merge(
		{
			Environment = var.environment
			Project     = var.project
		},
		var.extra_tags
	)
}
```
Redukuje duplikację i ryzyko literówek.

## Outputs – kontrakt modułu
```hcl
output "storage_account_name" {
	value       = azurerm_storage_account.this.name
	description = "Nazwa konta storage do dalszych referencji"
}
```
Zawsze opis – konsument wie czy output jest wrażliwy.

## Walidacje
```hcl
variable "environment" {
	type = string
	validation {
		condition     = can(regex("^(dev|test|prod)$", var.environment))
		error_message = "Environment must be dev|test|prod"
	}
}
```

## Refaktoryzacja: moved block
```hcl
moved {
	from = azurerm_storage_account.old_name
	to   = azurerm_storage_account.this
}
```
Zapobiega rekreacji – przenosi adres stanu.

## Testowanie – taktyka
| Warstwa | Narzędzie | Zakres |
|---------|----------|--------|
| Fmt/Lint | terraform fmt / tflint | Styl, podstawowe reguły |
| Security | checkov / tfsec | Polityki bezpieczeństwa |
| Jednostkowe | Terratest | Istnienie / właściwości zasobów |
| Integracyjne | Ręczny plan/apply w sandbox | Całościowa zgodność |

## Anti‑patterns
- Moduł łączący sieć, storage, compute i security – zbyt rozległy.
- Brak wersjonowania – konsumenci dostają breaking changes.
- Outputy z sekretami (hasło admina) – naruszenie bezpieczeństwa stanu.

## Ćwiczenie
Dodaj walidację do modułu storage: dozwolone tylko LRS/GRS. Spróbuj użyć ZRS – sprawdź komunikat.

## Efekt końcowy
- Moduły czytelne, testowalne, z kontraktem wejść/wyjść.

## Następny krok
Zaawansowane typy i datasources (`Rozdział 7`).

## Zakres tematyczny
- Outputs i locals w modułach — jak przekazywać i przetwarzać dane.
- Warunki i walidacje wejść (validation blocks, constraints).
- Testowanie modułów: przykłady, testy automatyczne (np. Terratest, Checkov).
- Refaktoryzacja i rozwój modułów — jak unikać duplikacji i antywzorców.
- Przykłady dobrych praktyk: dokumentacja, wersjonowanie, reużywalność.

## Wskazówki
- Stosuj locals do przetwarzania i agregacji danych wejściowych.
- Outputs ułatwiają przekazywanie wyników między modułami.
- Waliduj wejścia, by uniknąć błędów na etapie planowania.
- Testuj moduły automatycznie i manualnie.

## Efekt końcowy
- Umiejętność budowy zaawansowanych, testowalnych modułów.
- Świadomość dobrych praktyk i narzędzi do rozwoju modułów.
- Gotowość do pracy z dużymi, złożonymi projektami Terraform.
