# Indeks rozdziałów — Szkolenie zaawansowane Terraform

## Dzień 1: Moduły, Backendy, Import, Rozwój

### [Rozdział 1: Wprowadzenie i przygotowanie środowiska](rozdzial_1.md)
Omówienie celu szkolenia, konfiguracja narzędzi, logowanie do Azure, przygotowanie repozytorium.  
**Laboratorium:** [lab_advanced_1](../lab/lab_advanced_1/)

### [Rozdział 2: Modularność w Terraform](rozdzial_2.md)
Count, for_each, dynamic blocks, praktyczne wdrożenie (Storage Account, NSG).  
**Laboratorium:** [lab_advanced_2](../lab/lab_advanced_2/)

### [Rozdział 3: Remote backends](rozdzial_3.md)
Konfiguracja zdalnego backendu (Azure Storage), bezpieczeństwo, blokady, praca zespołowa.  
**Laboratorium:** [lab_advanced_3](../lab/lab_advanced_3/)

### [Rozdział 4: Repozytorium artefaktów, rozwój modułów](rozdzial_4.md)
Publikacja i wersjonowanie modułów, standardy organizacyjne, współpraca.  
**Laboratorium:** [lab_advanced_4](../lab/lab_advanced_4/)

### [Rozdział 5: Import zasobów](rozdzial_5.md)
Praktyczne ćwiczenie importu istniejących zasobów do stanu Terraform.  
**Laboratorium:** [lab_advanced_5](../lab/lab_advanced_5/)

### [Rozdział 6: Pogłębienie pracy z modułami](rozdzial_6.md)
Zaawansowane techniki budowy i testowania modułów, outputs, locals, walidacja.  
**Laboratorium:** [lab_advanced_6](../lab/lab_advanced_6/)

---

## Dzień 2: Zmienne, Walidacja, CI/CD

### [Rozdział 7: Zmienne, locals, typy danych, datasources](rozdzial_7.md)
Praca z typami danych, obiektami, locals, plikami tfvars, warunkami i datasources.  
**Laboratorium:** [lab_advanced_7](../lab/lab_advanced_7/)

### [Rozdział 8: Integracja z CI/CD, pipelines](rozdzial_8.md)
Budowa pipeline, automatyzacja wdrożeń, walidacja kodu (fmt, tflint, checkov), approval flow.  
**Laboratorium:** [lab_advanced_8](../lab/lab_advanced_8/)

### [Rozdział 9: Standardy walidacji i bezpieczeństwa](rozdzial_9.md)
Wdrażanie walidacji, narzędzia do analizy bezpieczeństwa, przykłady reguł i polityk.  
**Laboratorium:** [lab_advanced_9](../lab/lab_advanced_9/)

---

## Dzień 3: Standardy, Hardenowanie, Pipeline, Złożone Środowiska

### [Rozdział 10: Standardy organizacyjne, hardenowanie](rozdzial_10.md)
Tworzenie i egzekwowanie standardów organizacyjnych, walidacja zasobów, hardenowanie modułów.  
**Laboratorium:** [lab_advanced_10](../lab/lab_advanced_10/)

### [Rozdział 11: Terragrunt, Terramate](rozdzial_11.md)
Przegląd narzędzi wspierających zarządzanie infrastrukturą, porównanie, demo.  
**Laboratorium:** [lab_advanced_11](../lab/lab_advanced_11/)

### [Rozdział 12: Budowa złożonego środowiska](rozdzial_12.md)
Praktyczne wdrożenie złożonego środowiska (VNet, Storage, Key Vault, UAI), integracja z pipeline.  
**Laboratorium:** [lab_advanced_12](../lab/lab_advanced_12/)

### Lab dodatkowy: [Logic App Standard z Private VNet Integration](../lab/lab_advanced_13/)
Zaawansowana integracja Logic App z siecią wirtualną, Private Endpoints dla Storage, pełna izolacja sieciowa.  
**Laboratorium:** [lab_advanced_13](../lab/lab_advanced_13/)

---

## Moduły reużywalne
- [storage_account](../modules/storage_account/) — Storage Account z walidacją
- [network](../modules/network/) — VNet i Subnets
- [function_app](../modules/function_app/) — Azure Function App

---

[Powrót do głównego README](../README.md)
