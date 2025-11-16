# 📘 Agenda 3-dniowego szkolenia Terraform – Poziom Zaawansowany

## 📅 Dzień 1 – Moduły, Backend i HCL w Praktyce

| Godzina       | Temat                                                                                                 | Typ        |
|---------------|-------------------------------------------------------------------------------------------------------|------------|
| 09:00–09:15   | Otwarcie szkolenia, przedstawienie celu i planu                                                      | Teoria     |
| 09:15–10:30   | Powtórka podstaw: HCL, zmienne, tfvars, provider Azure, konfiguracja środowiska                      | Teoria     |
| 10:30–10:40   | ☕ Przerwa                                                                                            | Przerwa    |
| 10:40–11:20   | Remote backend i zarządzanie stanem Terraform                                                         | Teoria     |
| 11:20–12:00   | Ćwiczenia: konfiguracja zdalnego backendu (np. Azure Storage)                                         | Praktyka   |
| 12:00–12:30   | Wprowadzenie do modułów Terraform i struktury modułu                                                  | Teoria     |
| 12:30–13:10   | 🍽 Przerwa obiadowa                                                                                   | Lunch      |
| 13:10–14:20   | Ćwiczenie: tworzenie modułu wielokrotnego użytku (np. RG + Storage)                                  | Praktyka   |
| 14:20–14:30   | ☕ Przerwa                                                                                            | Przerwa    |
| 14:30–15:00   | Zaawansowane funkcje HCL: count, for_each, dynamic, locals                                           | Teoria     |
| 15:00–16:00   | Ćwiczenia: wdrożenie złożonych zasobów z użyciem for_each i dynamic blocks                           | Praktyka   |
| 16:00–16:10   | ☕ Przerwa                                                                                            | Przerwa    |
| 16:10–17:00   | Podsumowanie dnia, Q&A, najlepsze praktyki                                                            | Teoria     |

## 📅 Dzień 2 – Zmienność, Walidacja i CI/CD

| Godzina       | Temat                                                                                                 | Typ        |
|---------------|-------------------------------------------------------------------------------------------------------|------------|
| 09:00–09:15   | Powtórka dnia 1 i wprowadzenie do tematyki dnia                                                       | Teoria     |
| 09:15–10:00   | Data sources i integracja z istniejącą infrastrukturą                                                 | Teoria     |
| 10:00–10:30   | Ćwiczenia: użycie `data` i odczyt parametrów istniejących zasobów                                     | Praktyka   |
| 10:30–10:40   | ☕ Przerwa                                                                                            | Przerwa    |
| 10:40–11:30   | Hardenowanie i wersjonowanie modułów, ograniczenia wartości (np. zakaz `account_key` w Storage)      | Teoria     |
| 11:30–12:30   | Ćwiczenia: walidacja zmiennych, ograniczenia, struktura organizacyjna                                | Praktyka   |
| 12:30–13:10   | 🍽 Przerwa obiadowa                                                                                   | Lunch      |
| 13:10–14:00   | CI/CD z Terraform: GitHub Actions, zatwierdzenia, workflow PR                                        | Teoria     |
| 14:00–14:30   | Walidacja kodu: `fmt`, `validate`, `tflint`, `checkov`, pre-commit                                   | Teoria     |
| 14:30–14:40   | ☕ Przerwa                                                                                            | Przerwa    |
| 14:40–15:20   | Ćwiczenia: integracja pre-commit i walidatorów kodu                                                  | Praktyka   |
| 15:20–16:00   | Wprowadzenie do narzędzi: Terragrunt i Terramate                                                     | Teoria     |
| 16:00–16:10   | ☕ Przerwa                                                                                            | Przerwa    |
| 16:10–17:00   | Sesja Q&A, porządkowanie wiedzy, przygotowanie do dnia 3                                             | Teoria     |

## 📅 Dzień 3 – Projekt Końcowy i Standardy Organizacyjne

| Godzina       | Temat                                                                                                 | Typ        |
|---------------|-------------------------------------------------------------------------------------------------------|------------|
| 09:00–09:30   | Standardy organizacyjne: struktura repozytoriów, monorepo vs multirepo, wersjonowanie                 | Teoria     |
| 09:30–10:30   | Projekt – wprowadzenie: AIFoundry, KeyVault, UAI, FunctionApp, NSG                                    | Teoria     |
| 10:30–10:40   | ☕ Przerwa                                                                                            | Przerwa    |
| 10:40–12:30   | Projekt – cz. 1: budowa sieci, Storage, KeyVault, integracje                                          | Praktyka   |
| 12:30–13:10   | 🍽 Przerwa obiadowa                                                                                   | Lunch      |
| 13:10–14:30   | Projekt – cz. 2: usługi aplikacyjne (FunctionApp, AppInsights), konfiguracja dostępu                  | Praktyka   |
| 14:30–14:40   | ☕ Przerwa                                                                                            | Przerwa    |
| 14:40–16:00   | Projekt – cz. 3: testy, walidacja, PR flow i zatwierdzenia                                            | Praktyka   |
| 16:00–16:10   | ☕ Przerwa                                                                                            | Przerwa    |
| 16:10–17:00   | Podsumowanie, omówienie projektu, pytania, zakończenie                                               | Teoria     |