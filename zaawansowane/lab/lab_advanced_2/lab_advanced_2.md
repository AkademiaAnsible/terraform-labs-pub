# Lab Advanced 2: Modularność, count, for_each, dynamic

## Cel laboratorium
- Przećwiczyć wykorzystanie count, for_each i dynamic blocks w praktyce.
- Utworzyć wiele Storage Account oraz NSG z dynamicznymi regułami.

## Krok po kroku
1. Przejdź do katalogu laboratorium: `cd zaawansowane/lab/lab_advanced_2`.
2. Zainicjuj Terraform: `terraform init -backend-config=backend.hcl`.
3. Zweryfikuj konfigurację: `terraform validate`.
4. Przeprowadź planowanie: `terraform plan -var-file=dev.tfvars`.
5. (Opcjonalnie) Utwórz zasoby: `terraform apply -var-file=dev.tfvars`.

## Wyjaśnienia
- Zmienna `storage_accounts` pozwala utworzyć dowolną liczbę Storage Account (for_each).
- Zmienna `nsg_rules` pozwala zdefiniować listę reguł NSG (dynamic block).
- Możesz modyfikować wartości w `dev.tfvars` i obserwować zmiany w planie.

## Efekt końcowy
- Utworzone Storage Account i NSG z regułami.
- Zrozumienie mechanizmów count, for_each, dynamic w Terraform.
