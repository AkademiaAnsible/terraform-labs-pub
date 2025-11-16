# Agenda szkolenia zaawansowanego Terraform (3 dni, 8h/dzień)

## Dzień 1: Moduły, Backendy, Import, Rozwój

**09:00–10:30**  
_Wprowadzenie, przygotowanie środowiska_  
Opis: Omówienie celu szkolenia, konfiguracja narzędzi, logowanie do Azure, przygotowanie repozytorium, wstęp do pracy z Terraform.
Wyrównanie wiedzy
Lab 0a - konfiguracja środowiska
Lab 1a - storage ze wspólnego modułu
Lab 2a - konfiguracja remote backend, i tf migrate

**10:30–10:40**  
_Przerwa_

**10:40–13:00**  
_Modularność w Terraform: count, for_each, dynamic blocks, praktyka (np. Container Apps + sekret z Key Vault, NSG lub Storage)_  
Opis: Praca z modułami, parametryzacja, iteracja po zasobach, dynamiczne bloki. Praktyczne wdrożenie: Container Apps z sekretem z Key Vault lub Storage z NSG.

**13:00–13:40**  
_Obiad_

**13:40–14:40**  
_Remote backends w Terraform_  
Opis: Konfiguracja zdalnego backendu (Azure Storage), bezpieczeństwo, blokady, praca zespołowa.

Lab: praca na wspólnym backend

**14:40–15:40**  
_Repozytorium artefaktów, rozwój modułów w organizacji_  
Opis: Przegląd repozytoriów (np. Artifactory, Terraform Registry), publikacja i wersjonowanie modułów, standardy organizacyjne.

**15:40–15:50**  
_Przerwa_

**15:50–16:50**  

_Pogłębienie pracy z modułami_  
Opis: Zaawansowane techniki budowy i testowania modułów, reużywalność, best practices.

---

## Dzień 2: Zmienne, Walidacja, CI/CD

**09:00–10:30**  
_Zmienne, locals, typy danych, złożone struktury, tfvars, warunki, datasources_  
Opis: Praca z typami danych, obiektami, locals, plikami tfvars, warunkami i datasources. Praktyczne przykłady.
_Import zasobów do Terraform_  
Opis: Praktyczne ćwiczenie importu istniejących zasobów do stanu Terraform, typowe problemy i rozwiązania.

Lab tf state rm mv import

**10:30–10:40**  
_Przerwa_

**10:40–13:00**  
_Integracja z CI/CD, pipelines w GitHub Enterprise_  
Opis: Budowa pipeline, automatyzacja wdrożeń, walidacja kodu (fmt, tflint, checkov), approval flow, testy PR.
Lab - budowa github workflow z sprawdzeniami, walidacją itp
przykładowy oficjalny pipeline od Azure

**13:00–13:40**  
_Obiad_

**13:40–15:40**  
_Standardy walidacji i bezpieczeństwa kodu_  
Opis: Wdrażanie walidacji, narzędzia do analizy bezpieczeństwa, przykłady reguł i polityk.

**15:40–15:50**  
_Przerwa_

**15:50–17:00**  
_HCP Terraform lub alternatywa: demo, dyskusja_  
Opis: Przegląd HCP Terraform, demo, alternatywy (np. Terragrunt, Terramate), dyskusja o wdrożeniach w organizacji.

---

## Dzień 3: Standardy, Hardenowanie, Pipeline, Złożone Środowiska

**09:00–10:30**  
_Corpo standardy, moduły organizacyjne, validate na zasobach_  
Opis: Tworzenie i egzekwowanie standardów organizacyjnych, walidacja zasobów, przykłady polityk.

**10:30–10:40**  
_Przerwa_

**10:40–12:40**  
_Hardenowanie modułów, blokowanie niepożądanych wartości, exclude_  
Opis: Praktyczne przykłady hardenowania kodu, blokowanie niepożądanych wartości (np. account key w Storage), mechanizmy exclude.
Lab z validate imputu

**12:40–13:20**  
_Obiad_

**13:20–14:20**  
_Terragrunt, Terramate i inne narzędzia_  
Opis: Przegląd narzędzi wspierających zarządzanie infrastrukturą, porównanie, demo.

**14:20–16:20**  
_Budowa złożonego środowiska: AIFoundry, AIServices, Encryption (KV + key), UAI, FunctionApp, Storage, pipeline, PR, testy, zatwierdzenie_  
Opis: Praktyczne wdrożenie złożonego środowiska, integracja z pipeline, testy, proces zatwierdzania.

**16:20–17:00**  
_Inne tematy, Q&A, podsumowanie_  
Opis: Dyskusja o innych zagadnieniach, pytania uczestników, podsumowanie szkolenia.

---
