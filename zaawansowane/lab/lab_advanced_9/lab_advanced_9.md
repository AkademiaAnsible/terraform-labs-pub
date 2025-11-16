# Lab Advanced 9: Walidacja i bezpieczeństwo kodu

## Cel laboratorium
- Przećwiczyć automatyczną walidację i testy bezpieczeństwa kodu Terraform.
- Wykryć i naprawić błąd bezpieczeństwa (publiczny dostęp do Storage Account).

## Krok po kroku
1. Przejdź do katalogu laboratorium: `cd zaawansowane/lab/lab_advanced_9`.
2. Zainstaluj narzędzia: tflint, checkov, tfsec, pre-commit.
3. Uruchom walidację: `terraform validate`, `tflint`, `checkov`, `tfsec`.
4. Zidentyfikuj błąd bezpieczeństwa (publiczny dostęp do Storage Account).
5. Popraw kod i powtórz walidację.
6. (Opcjonalnie) Skonfiguruj pre-commit hook do automatycznej walidacji.

## Wyjaśnienia
- Narzędzia tflint, checkov, tfsec wykrywają błędy i podatności.
- Pre-commit automatyzuje walidację przed każdym commitem.
- Przykład Storage Account z publicznym dostępem — niezgodne z polityką.

## Efekt końcowy
- Wykryty i naprawiony błąd bezpieczeństwa.
- Automatyczna walidacja kodu przed wdrożeniem.
