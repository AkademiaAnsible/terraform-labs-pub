# Rozdział 4: Repozytorium artefaktów, rozwój modułów w organizacji

## Cel rozdziału
- Poznasz rolę repozytoriów artefaktów w zarządzaniu modułami Terraform.
- Nauczysz się publikować, wersjonować i rozwijać moduły w organizacji.
- Zrozumiesz standardy i dobre praktyki rozwoju modułów.

## Cykl życia modułu
1. Projekt (identyfikacja wspólnego wzorca).
2. Implementacja (main.tf, variables.tf, outputs.tf, README).
3. Testy (terratest, lint, security scan).
4. Wersjonowanie (tag v1.0.0, semver polityka).
5. Publikacja (private registry / public terraform registry).
6. Konsumpcja (module block + wersja).

## Struktura przykładowego modułu
```text
modules/storage_account/
	main.tf
	variables.tf
	outputs.tf
	README.md
	examples/
		simple/main.tf
```

`variables.tf` (fragment):
```hcl
variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "replication" {
	type        = string
	default     = "LRS"
	validation {
		condition     = contains(["LRS","GRS","ZRS"], var.replication)
		error_message = "Replication must be one of LRS|GRS|ZRS"
	}
}
```

`main.tf` (fragment):
```hcl
resource "azurerm_storage_account" "this" {
	name                     = substr("st${var.name_prefix}sa", 0, 24)
	location                 = var.location
	resource_group_name      = var.resource_group_name
	account_tier             = "Standard"
	account_replication_type = var.replication
	tags                     = var.tags
}
```

`outputs.tf`:
```hcl
output "primary_blob_endpoint" {
	value       = azurerm_storage_account.this.primary_blob_endpoint
	description = "URL endpoint for blob operations"
}
```

## README – kluczowe elementy
- Opis celu modułu.
- Tabela wejść/wyjść.
- Przykład użycia.
- Wymagania wersji Terraform / provider.

## Testy (zarys terratest Go)
```go
func TestStorageModule(t *testing.T) {
	terraformOptions := &terraform.Options{TerraformDir: "../../examples/simple"}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	endpoint := terraform.Output(t, terraformOptions, "primary_blob_endpoint")
	require.Contains(t, endpoint, "blob.core")
}
```

## Standardy organizacyjne
| Obszar | Zalecenie |
|--------|-----------|
| Nazewnictwo | `mod-<nazwa>` repo, czytelne prefixy zasobów |
| Semver | Major dla breaking changes, Minor dla funkcji, Patch dla poprawek |
| Dokumentacja | Każdy moduł: README + examples |
| Bezpieczeństwo | Brak sekretów w outputach, walidacje wartości krytycznych |
| CI | Fmt, lint, security scan, testy | 

## Pułapki
- Brak stabilnej nazwy → częste rekreacje.
- Nadmiar parametrów 1:1 z zasobem → brak abstrakcji.
- Brak testów → nieświadome regresje.

## Ćwiczenie
Utwórz moduł dla Key Vault (parametry: purge_protection_enabled, soft_delete_retention_days) + export nazwy.

## Efekt końcowy
- Proces tworzenia modułu ustandaryzowany.
- Gotowy szablon do reużycia.

## Następny krok
Import istniejących zasobów (`Rozdział 5`).

## Zakres tematyczny
- Czym jest repozytorium artefaktów? (np. Terraform Registry, Artifactory, GitHub Packages)
- Publikacja i wersjonowanie modułów.
- Przykład rejestracji i użycia własnego modułu.
- Standardy organizacyjne: naming, dokumentacja, testy, CI/CD.
- Przegląd narzędzi wspierających rozwój modułów.
- Współpraca i rozwój modułów w zespole.

## Wskazówki
- Stosuj wersjonowanie semantyczne (semver) dla modułów.
- Dokumentuj wejścia, wyjścia i przykłady użycia.
- Wdrażaj testy i walidację kodu (tflint, checkov, pre-commit).
- Wspieraj reużywalność i czytelność kodu.

## Efekt końcowy
- Umiejętność publikacji i użycia własnych modułów.
- Świadomość standardów i narzędzi do rozwoju modułów w organizacji.
- Gotowość do pracy z prywatnym lub publicznym rejestrem modułów.
