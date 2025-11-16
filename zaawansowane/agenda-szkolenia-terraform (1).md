
# Plan Szkolenia Terraform (Azure – Poziom Zaawansowany) – 3 dni

## Dzień 1 (9:00–17:00) – **Moduły i Zaawansowane Funkcje HCL**

- **9:00–9:30 – Wprowadzenie i konfiguracja:** Powitanie uczestników, omówienie celów szkolenia oraz agendy. Sprawdzenie przygotowania środowiska – dostęp do Azure, zainstalowany Terraform i Azure CLI, wymagane wtyczki. Przypomnienie zasad **Infrastructure as Code** i cyklu pracy Terraform (format -> plan -> apply -> destroy). Podkreślenie kluczowych dobrych praktyk, które będą przewijać się w szkoleniu.

- **9:30–10:30 – Terraform w zespołach: dobre praktyki (1 h):** Dyskusja o typowych wyzwaniach przy pracy z Terraformem w organizacji. Omówienie architektury Terraform i współdzielenia kodu. Wskazanie rozwiązań: **moduły**, **zdalny backend stanu**, weryfikacja zmian przez PR i `plan`.

- **10:30–10:40 – Przerwa kawowa (10 min)**

- **10:40–12:00 – Terraform **Moduły** – projektowanie i użycie (1h20):** Struktura modułu, wersjonowanie, publikacja w registry, interfejs modułu, parametryzacja. Pokaz tworzenia modułu.

- **12:00–12:40 – Przerwa lunch (40 min)**

- **12:40–14:10 – **Zaawansowany HCL** – count, for_each, dynamic (1h30):** Omówienie `count`, `for_each`, `dynamic`, różnice i zastosowania. Ćwiczenie: dodawanie dynamicznych zasobów.

- **14:10–14:20 – Przerwa (10 min)**

- **14:20–15:50 – **Ćwiczenie praktyczne:** budowa modułu Azure (1h30):** Praktyczne wdrożenie: Function App + UAI + Key Vault. Moduły, pętle, szyfrowanie.

- **15:50–16:00 – Przerwa (10 min)**

- **16:00–17:00 – Omówienie wyników i podsumowanie dnia:** Przegląd rozwiązań, dyskusja, Q&A.

## Dzień 2 (9:00–17:00) – **Zarządzanie stanem, Środowiska i CI/CD**

- **9:00–10:30 – Zdalny **State** i zarządzanie stanem (1h30):** Znaczenie state, konfiguracja zdalnego backendu, `terraform import`, bezpieczeństwo i operacje na stanie.

- **10:30–10:40 – Przerwa (10 min)**

- **10:40–12:00 – **Wiele środowisk** i struktura repozytorium (1h20):** Workspaces vs katalogi, `tfvars`, `locals`, `datasources`, struktury monorepo vs multirepo, Terragrunt i Terramate.

- **12:00–12:40 – Przerwa lunch (40 min)**

- **12:40–14:10 – **Integracja z CI/CD i walidacja kodu** (1h30):** Pipeline: `fmt`, `validate`, `TFLint`, `Checkov`, plan w PR, approval i apply.

- **14:10–14:20 – Przerwa (10 min)**

- **14:20–15:50 – **Ćwiczenie:** workflow zespołowy z Terraform (1h30):** PR z kodem Terraform, analiza planu, review, zatwierdzenie, apply.

- **15:50–16:00 – Przerwa (10 min)**

- **16:00–17:00 – Podsumowanie dnia 2 i dyskusja:** Omówienie procesów CI/CD, state, repozytoriów, Q&A.

## Dzień 3 (9:00–17:00) – **Standardy organizacyjne i przypadki zaawansowane**

- **9:00–10:30 – **Standardy i zaawansowane funkcje Terraform** (1h30):** Governance, registry prywatne, polityki, `templatefile`, `try`, `coalesce`, trendy IaC.

- **10:30–10:40 – Przerwa (10 min)**

- **10:40–12:30 – **Ćwiczenie końcowe (część 1):** Zaawansowany projekt na Azure (1h50):** Projektowanie i wdrożenie środowiska z FunctionApp + AI Services + UAI + KeyVault.

- **12:30–13:10 – Przerwa lunch (40 min)**

- **13:10–14:30 – **Ćwiczenie końcowe (część 2):** Weryfikacja i testy (1h20):** testy działania infrastruktury, sprawdzanie CI/CD, TFLint, Checkov.

- **14:30–14:40 – Przerwa (10 min)**

- **14:40–16:00 – Prezentacje rozwiązań i omówienie (1h20):** Grupy prezentują rezultaty, review, dyskusja.

- **16:00–16:10 – Przerwa (10 min)**

- **16:10–17:00 – Podsumowanie szkolenia i Q&A:** Najważniejsze wnioski, dalsze kroki, dokumentacja, wymiana doświadczeń.
