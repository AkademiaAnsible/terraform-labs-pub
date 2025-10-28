# Lab 2: Konfiguracja zdalnego backendu w Azure Storage

## Cel

Celem tego laboratorium jest skonfigurowanie zdalnego backendu dla stanu Terraform. Przechowywanie stanu w zdalnym, współdzielonym miejscu (jak Azure Storage Account) jest kluczowe dla pracy zespołowej i bezpieczeństwa.

W tym labie utworzysz również kontener o nazwie **mojstan** w swoim koncie magazynu Azure, który będzie służył do przechowywania pliku stanu `terraform.tfstate`.

## Kroki

1.  **Utwórz zasoby dla backendu:**
        *   Potrzebujemy konta magazynu (Storage Account) i **kontenera o nazwie `mojstan`** (Storage Container), gdzie będzie przechowywany plik `terraform.tfstate`.
        *   Kontener powinien mieć dokładnie nazwę `mojstan`.
        *   Możesz to zrobić ręcznie przez portal Azure, za pomocą Azure CLI lub używając oddzielnej konfiguracji Terraform. W `skrypt.sh` znajdziesz przykład użycia Azure CLI.
        *   Przykład polecenia Azure CLI do utworzenia kontenera:
            ```bash
            az storage container create \
                --name mojstan \
                --account-name <twoje_konto_storage> \
                --auth-mode login
            ```

2.  **Przejrzyj pliki konfiguracyjne:**
    *   `backend.tf`: Zawiera pustą deklarację backendu `azurerm`. Wartości przekazujemy podczas `terraform init` przez `-backend-config` (robi to skrypt).
    *   `main.tf`, `variables.tf`, `outputs.tf`: Bazują na Lab 1, ale nazwa konta magazynu to teraz `storage_account_prefix` + losowy sufiks (provider `random`).

3.  **Zainicjuj Terraform z nowym backendem:**
    *   Uruchom `./skrypt.sh`, który utworzy zasoby backendu (RG, SA, kontener) i wykona `terraform init -reconfigure` z odpowiednimi `-backend-config`.

4.  **Sprawdź plan i wdróż zasoby:**
    *   Uruchom `terraform plan` i `terraform apply`. Możesz użyć `-var-file=dev.tfvars` albo zmiennych środowiskowych `TF_VAR_*` (tak jak w Lab 1). Plik stanu będzie zarządzany w Azure Storage.

5.  **Sprawdź plik stanu w Azure:**
    *   Przejdź do swojego konta magazynu w portalu Azure, znajdź kontener i zobaczysz w nim plik `terraform.tfstate`.

6.  **Posprzątaj zasoby:**
    *   Uruchom `terraform destroy`, aby usunąć zasoby zdefiniowane w `main.tf`.
    *   Zasoby backendu (RG/SA/kontener) nie są usuwane automatycznie. Usuń je ręcznie, jeśli nie będą potrzebne.

## Pliki

*   `lab2/backend.tf`
*   `lab2/main.tf`
*   `lab2/variables.tf`
*   `lab2/outputs.tf`
*   `lab2/skrypt.sh`
