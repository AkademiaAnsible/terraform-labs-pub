# Checklista szkolenia zaawansowanego Terraform

## Dzień 1: Moduły, Backendy, Import, Rozwój

### ✅ Wprowadzenie i przygotowanie środowiska (09:00–10:30)
- [ ] Zainstalowano Terraform >= 1.5
- [ ] Zainstalowano Azure CLI
- [ ] Wykonano logowanie do Azure (`az login`)
- [ ] Skonfigurowano subskrypcję Azure
- [ ] Sklonowano repozytorium z ćwiczeniami
- [ ] Ukończono lab_advanced_1

### ✅ Modularność w Terraform (10:40–13:00)
- [ ] Zrozumiano różnice między count a for_each
- [ ] Przećwiczono dynamic blocks
- [ ] Utworzono powtarzalne zasoby (Storage Account, NSG)
- [ ] Ukończono lab_advanced_2

### ✅ Remote backends (13:40–14:40)
- [ ] Skonfigurowano backend Azure Storage
- [ ] Przetestowano blokady stanu
- [ ] Ukończono lab_advanced_3

### ✅ Repozytorium artefaktów (14:40–15:40)
- [ ] Zrozumiano zasady publikacji modułów
- [ ] Utworzono i przetestowano własny moduł
- [ ] Ukończono lab_advanced_4

### ✅ Import zasobów (15:50–16:50)
- [ ] Wykonano import istniejącej grupy zasobów
- [ ] Rozwiązano różnice między kodem a stanem
- [ ] Ukończono lab_advanced_5

### ✅ Pogłębienie pracy z modułami (16:50–18:00)
- [ ] Zastosowano outputs i locals w modułach
- [ ] Dodano walidację wejść
- [ ] Ukończono lab_advanced_6

---

## Dzień 2: Zmienne, Walidacja, CI/CD

### ✅ Zmienne, locals, typy danych (09:00–10:30)
- [ ] Przećwiczono złożone struktury (objects, maps)
- [ ] Zastosowano locals do agregacji danych
- [ ] Użyto datasources do pobierania informacji
- [ ] Ukończono lab_advanced_7

### ✅ Integracja z CI/CD (10:40–13:00)
- [ ] Skonfigurowano pipeline GitHub Actions
- [ ] Zautomatyzowano walidację kodu
- [ ] Przetestowano approval flow
- [ ] Ukończono lab_advanced_8

### ✅ Standardy walidacji i bezpieczeństwa (13:40–15:40)
- [ ] Zainstalowano tflint, checkov, tfsec
- [ ] Wykryto i naprawiono błąd bezpieczeństwa
- [ ] Skonfigurowano pre-commit hooks
- [ ] Ukończono lab_advanced_9

---

## Dzień 3: Standardy, Hardenowanie, Złożone Środowiska

### ✅ Standardy organizacyjne (09:00–10:30)
- [ ] Wdrożono validate na zmiennych
- [ ] Zastosowano hardenowanie Storage Account
- [ ] Ukończono lab_advanced_10

### ✅ Terragrunt, Terramate (13:20–14:20)
- [ ] Przetestowano Terragrunt lub Terramate
- [ ] Zrozumiano zarządzanie wieloma środowiskami
- [ ] Ukończono lab_advanced_11

### ✅ Budowa złożonego środowiska (14:20–16:20)
- [ ] Zintegrowano wiele modułów (VNet, Storage, Key Vault, UAI)
- [ ] Skonfigurowano pipeline z testami
- [ ] Przetestowano proces PR i zatwierdzenia
- [ ] Ukończono lab_advanced_12

### ✅ Podsumowanie (16:20–17:00)
- [ ] Zadano pytania i wyjaśniono wątpliwości
- [ ] Omówiono dalsze kroki i zasoby
- [ ] Oceniono szkolenie

---

## Dodatkowe zasoby
- [ ] Terraform Documentation: https://www.terraform.io/docs
- [ ] Azure Provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- [ ] Terraform Best Practices: https://www.terraform-best-practices.com
- [ ] Repozytorium z przykładami: https://github.com/sirkubax/terraform-labs
