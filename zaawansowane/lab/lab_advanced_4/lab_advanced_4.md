# Lab Advanced 4: Moduł Storage Account i publikacja do rejestru

## Cel laboratorium
- Utworzyć własny moduł Terraform (Storage Account).
- Wykorzystać moduł lokalnie, a następnie przygotować do publikacji w rejestrze.

## Krok po kroku
1. Utwórz katalog `modules/storage_account` i zaimplementuj prosty moduł (resource, variables, outputs).
2. Skonfiguruj wywołanie modułu w `main.tf`.
3. Przetestuj lokalnie: `terraform init`, `terraform plan`, `terraform apply`.
4. Przygotuj dokumentację modułu (README.md, examples).
5. (Opcjonalnie) Skonfiguruj pipeline do publikacji do rejestru (np. GitHub Registry).

## Wyjaśnienia
- Moduły pozwalają na reużywalność i standaryzację kodu.
- Przykład lokalny — w organizacji możesz korzystać z rejestru prywatnego.
- Dokumentacja i wersjonowanie są kluczowe dla rozwoju modułów.

## Efekt końcowy
- Utworzony i przetestowany moduł Storage Account.
- Gotowość do publikacji i użycia w innych projektach.
