# Lab Advanced 10: Standardy organizacyjne, validate, hardenowanie, exclude

## Cel laboratorium
- Przećwiczyć egzekwowanie standardów organizacyjnych w kodzie Terraform.
- Wdrożyć validate na zmiennych, hardenowanie Storage Account, mechanizm exclude.

## Krok po kroku
1. Przejdź do katalogu laboratorium: `cd zaawansowane/lab/lab_advanced_10`.
2. Przeanalizuj validate na zmiennych (`variables.tf`).
3. Zainicjuj Terraform: `terraform init -backend-config=backend.hcl`.
4. Zweryfikuj konfigurację: `terraform validate`.
5. Przeprowadź planowanie: `terraform plan -var-file=dev.tfvars`.
6. (Opcjonalnie) Ustaw `exclude_public_access = false` i sprawdź efekt.

## Wyjaśnienia
- Blok validate wymusza standardy na wejściach.
- Hardenowanie: Storage Account bez publicznego dostępu, wymuszony TLS.
- Mechanizm exclude: możliwość wyłączenia zabezpieczenia (np. dla testów, z dokumentacją wyjątku).

## Efekt końcowy
- Skonfigurowane standardy organizacyjne i hardenowanie zasobów.
- Mechanizm exclude do kontrolowanego odstępstwa od polityki.
