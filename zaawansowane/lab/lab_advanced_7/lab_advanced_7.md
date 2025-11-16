# Lab Advanced 7: Zmienne, locals, typy danych, tfvars, warunki, datasources

## Cel laboratorium
- Przećwiczyć zaawansowane typy zmiennych, locals, pliki tfvars, warunki i datasources.
- Utworzyć VNet i podsieci na podstawie złożonych struktur danych.

## Krok po kroku
1. Przejdź do katalogu laboratorium: `cd zaawansowane/lab/lab_advanced_7`.
2. Zainicjuj Terraform: `terraform init -backend-config=backend.hcl`.
3. Zweryfikuj konfigurację: `terraform validate`.
4. Przeprowadź planowanie: `terraform plan -var-file=dev.tfvars`.
5. (Opcjonalnie) Utwórz zasoby: `terraform apply -var-file=dev.tfvars`.

## Wyjaśnienia
- Zmienna `subnets` to lista obiektów (złożona struktura).
- Locals agregują i przetwarzają dane wejściowe.
- Plik tfvars pozwala łatwo zmieniać konfigurację.
- Datasource pobiera dane o subskrypcji.

## Efekt końcowy
- Utworzony VNet i podsieci na podstawie złożonych struktur.
- Zrozumienie locals, tfvars, warunków i datasources.
