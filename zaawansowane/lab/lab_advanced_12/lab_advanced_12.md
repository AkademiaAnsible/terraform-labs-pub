# Lab Advanced 12: Budowa złożonego środowiska, pipeline, testy, zatwierdzenie

## Cel laboratorium
- Przećwiczyć budowę złożonego środowiska z wieloma modułami (sieć, storage, function app).
- Zautomatyzować wdrożenie przez pipeline, testy i proces zatwierdzania.

## Krok po kroku
1. Przygotuj katalogi i moduły (`modules/network`, `modules/storage_account`, `modules/function_app`).
2. Skonfiguruj wywołania modułów w `main.tf`.
	- `module.network` tworzy VNet i podsieci.
	- `module.storage` tworzy Storage Account.
	- `data.azurerm_storage_account.storage` pobiera klucz dostępu.
	- `module.function_app` tworzy Function App (Linux Consumption) używając nazwy i klucza storage.
3. Zainicjuj Terraform: `terraform init -backend-config=backend.hcl`.
4. Zweryfikuj konfigurację: `terraform validate`.
5. Przeprowadź planowanie: `terraform plan -var-file=dev.tfvars`.
	- Zwróć uwagę na hostname Function App w outputach.
6. (Opcjonalnie) Skonfiguruj pipeline CI/CD do automatycznego wdrożenia i testów.
7. Przetestuj proces PR: review, testy, zatwierdzenie.

## Wyjaśnienia
- Moduły pozwalają na podział środowiska na logiczne komponenty.
- Function App wymaga nazwy konta Storage oraz klucza dostępowego (`primary_access_key`) do inicjalizacji środowiska wykonywania.
- Pipeline automatyzuje wdrożenie i testy.
- Approval flow zapewnia kontrolę zmian na produkcji.

## Efekt końcowy
- Złożone środowisko wdrożone i przetestowane przez pipeline.
- Bezpieczny, powtarzalny i kontrolowany proces wdrożeniowy.
