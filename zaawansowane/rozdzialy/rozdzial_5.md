# Rozdział 5: Import zasobów do Terraform

## Cel rozdziału
- Poznasz mechanizm importu istniejących zasobów do stanu Terraform.
- Nauczysz się mapować istniejące zasoby na kod HCL.
- Zrozumiesz typowe problemy i sposoby ich rozwiązywania.

## Dlaczego import?
Pozwala przejąć zarządzanie istniejącymi zasobami bez ich rekreacji. Umożliwia stopniowe wdrożenie Infrastructure as Code.

## Dwa podejścia
| Podejście | Mechanizm | Generuje kod? | Kiedy użyć |
|-----------|----------|---------------|------------|
| CLI `terraform import` | Wiąże obiekt z adresem stanu | Nie | Pojedyncze zasoby, szybkie przejęcie |
| Blok `import {}` (od 1.5+) | Deklaratywny opis importu | Tak (częściowo) | Masowe importy / PR review |

## Procedura CLI
1. Utwórz blok resource zgodny z doc providera.
2. Ustal pełny ID zasobu (Azure: format /subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Storage/storageAccounts/<name>). 
3. `terraform import azurerm_storage_account.existing /subscriptions/.../storageAccounts/name`.
4. `terraform plan` – dopasuj brakujące atrybuty.

## Przykład
```hcl
resource "azurerm_resource_group" "legacy" {
	name     = "rg-legacy"
	location = "westeurope"
}
```
```bash
terraform import azurerm_resource_group.legacy /subscriptions/xxx/resourceGroups/rg-legacy
```

## Typowe rozbieżności po imporcie
| Objaw | Powód | Działanie |
|-------|-------|-----------|
| Plan chce zmienić tag | Tag nie dopasowany | Dodaj tag do kodu |
| Rekreacja zasobu | Niewłaściwa nazwa / atrybut immutable | Skoryguj kod, nie zmieniaj unikalnych nazw |
| Nieznany atribut | Provider różni się wersją | Zaktualizuj provider lub usuń deprecated pole |

## Drift i audyt
Po imporcie wprowadź regułę: modyfikacje tylko przez Terraform. Regularne `plan` w CI aby wykrywać drift.

## Pułapki
- Import bez wcześniejszego bloku → stan powiąże zasób bez definicji (niezalecane).
- Import wielu zasobów tym samym adresem – konflikt w stanie.
- Pominięcie krytycznych właściwości (np. replication type) → plan proponuje zmianę.

## Ćwiczenie
Zaimportuj istniejący Key Vault (jeśli dostępny) i dopasuj atrybuty purge_protection.

## Efekt końcowy
- Umiejętność przejmowania istniejących zasobów.
- Świadomość ryzyka driftu.

## Następny krok
Zaawansowane moduły (`Rozdział 6`).

## Zakres tematyczny
- Po co importować zasoby do Terraform?
- Komenda `terraform import` — składnia, przykłady.
- Mapowanie zasobów: kod HCL vs. rzeczywisty stan w chmurze.
- Typowe problemy: brak zgodności, różnice w stanie, drift.
- Praktyczne wskazówki: jak przygotować kod, jak weryfikować import.
- Refaktoryzacja kodu po imporcie.

## Wskazówki
- Najpierw utwórz kod HCL odpowiadający zasobowi.
- Użyj `terraform import` z odpowiednim ID zasobu.
- Po imporcie wykonaj `terraform plan` i rozwiąż różnice.
- Dokumentuj proces importu i zmiany w kodzie.

## Efekt końcowy
- Umiejętność importu istniejących zasobów do Terraform.
- Świadomość typowych problemów i ich rozwiązań.
- Gotowość do migracji infrastruktury do zarządzania przez Terraform.
