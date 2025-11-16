# Szkolenie zaawansowane Terraform na Azure

## Struktura repozytorium

### Rozdziały (`rozdzialy/`)
Materiały teoretyczne podzielone na 12 rozdziałów pokrywających zaawansowane tematy Terraform:
1. Wprowadzenie i przygotowanie środowiska
2. Modularność (count, for_each, dynamic)
3. Remote backends
4. Repozytorium artefaktów i rozwój modułów
5. Import zasobów
6. Pogłębienie pracy z modułami
7. Zmienne, locals, typy danych, datasources
8. Integracja z CI/CD, pipelines
9. Standardy walidacji i bezpieczeństwa
10. Standardy organizacyjne, hardenowanie
11. Terragrunt, Terramate
12. Budowa złożonego środowiska

### Laboratoria (`lab/`)
Praktyczne laboratoria z plikami Terraform, zmiennymi, dokumentacją:
- `lab_advanced_1` do `lab_advanced_12` - laboratoria podstawowe
- `lab_advanced_13` - Logic App Standard z Private VNet Integration (lab dodatkowy)

### Moduły (`modules/`)
Reużywalne moduły Terraform:
- `storage_account` - moduł Storage Account z walidacją i dokumentacją
- `network` - moduł VNet i Subnet (do dodania)
- `function_app` - moduł Function App (do dodania)

## Wymagania
- Terraform >= 1.5
- Azure CLI
- Konto Azure z odpowiednimi uprawnieniami
- (Opcjonalnie) tflint, checkov, tfsec, pre-commit

## Jak korzystać
1. Zapoznaj się z materiałami teoretycznymi w `rozdzialy/`
2. Przejdź do odpowiedniego laboratorium w `lab/lab_advanced_X/`
3. Postępuj zgodnie z instrukcjami w `lab_advanced_X.md`
4. Eksperymentuj i modyfikuj kod

## Agenda szkolenia
Zobacz plik `agenda_zaawansowana.md` dla szczegółowego harmonogramu 3-dniowego szkolenia.
