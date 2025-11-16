# Lab Advanced 5: Import zasobów do Terraform

## Cel laboratorium
- Przećwiczyć import istniejącej grupy zasobów do stanu Terraform.
- Zrozumieć mapowanie kodu HCL na istniejący zasób.

## Krok po kroku
1. Upewnij się, że istnieje grupa zasobów w Azure (stwórz ją ręcznie lub przez portal).
2. Skonfiguruj pliki Terraform (`main.tf`, `variables.tf`, `dev.tfvars`) zgodnie z istniejącym zasobem.
3. Zainicjuj Terraform: `terraform init -backend-config=backend.hcl`.
4. Wykonaj import: `terraform import azurerm_resource_group.imported <nazwa_rg>`
5. Zweryfikuj stan: `terraform state list`, `terraform show`.
6. Przeprowadź planowanie: `terraform plan -var-file=dev.tfvars` i rozwiąż ewentualne różnice.

## Wyjaśnienia
- Import nie tworzy kodu HCL — musisz go przygotować samodzielnie.
- Po imporcie mogą pojawić się różnice — dostosuj kod lub zasób.
- Dokumentuj proces importu.

## Efekt końcowy
- Zaimportowana grupa zasobów, zarządzana przez Terraform.
- Zrozumienie procesu importu i typowych problemów.
