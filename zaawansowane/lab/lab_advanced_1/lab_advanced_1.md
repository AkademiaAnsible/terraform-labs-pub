# Lab Advanced 1: Wprowadzenie i przygotowanie środowiska

## Cel laboratorium
- Zweryfikować dostęp do Azure i repozytorium.
- Utworzyć pierwszą grupę zasobów za pomocą Terraform.
- Przećwiczyć podstawowe komendy: `terraform init`, `terraform plan`, `terraform apply`.

## Krok po kroku
1. Upewnij się, że masz zainstalowane: Terraform, Azure CLI, edytor kodu.
2. Zaloguj się do Azure: `az login`.
3. Skonfiguruj subskrypcję: `az account set --subscription <id>`.
4. Przejdź do katalogu laboratorium: `cd zaawansowane/lab/lab_advanced_1`.
5. Zainicjuj Terraform: `terraform init -backend-config=backend.hcl`.
6. Zweryfikuj konfigurację: `terraform validate`.
7. Przeprowadź planowanie: `terraform plan -var-file=dev.tfvars`.
8. (Opcjonalnie) Utwórz zasoby: `terraform apply -var-file=dev.tfvars`.

## Efekt końcowy
- Utworzona grupa zasobów w Azure.
- Zweryfikowane środowisko do dalszych ćwiczeń.
