# Lab 1: Wdrożenie Resource Group i Storage Account

## Cel

Celem tego laboratorium jest zapoznanie się z podstawowymi koncepcjami Terraform, takimi jak zasoby, zmienne i wartości wyjściowe. Wdrożymy grupę zasobów (Resource Group) oraz konto magazynu (Storage Account) w Azure.

## Kroki

1.  **Przejrzyj pliki konfiguracyjne:**
    *   `main.tf`: Zawiera definicje zasobów, które Terraform ma utworzyć.
        *   `variables.tf`: Deklaruje zmienne wejściowe, które pozwalają na parametryzację konfiguracji. Zmienna `storage_account_prefix` jest łączona z losowym sufiksem, by spełnić wymaganie unikalności nazwy.
    *   `outputs.tf`: Definiuje wartości wyjściowe, które będą wyświetlane po pomyślnym wdrożeniu.

2.  **Zainicjuj Terraform:**
        Otwórz terminal w folderze `lab1` i uruchom komendę `terraform init`. Spowoduje to pobranie niezbędnych dostawców (`azurerm`, `random`).

3.  **Sprawdź plan wdrożenia:**
    Uruchom `terraform plan`. Terraform pokaże, jakie zasoby zamierza utworzyć, zmodyfikować lub usunąć.

4.  **Wdróż zasoby:**
    Jeśli plan wygląda poprawnie, uruchom `terraform apply`. Terraform poprosi o potwierdzenie przed faktycznym utworzeniem zasobów w Azure.

5.  **Sprawdź wartości wyjściowe:**
    Po zakończeniu `apply`, Terraform wyświetli zdefiniowane wartości wyjściowe, takie jak nazwa grupy zasobów i konta magazynu.

6.  **Posprzątaj zasoby:**
    Aby usunąć wszystkie zasoby utworzone w tym laboratorium, uruchom `terraform destroy`.

## Wymagania wstępne

- Zalogowany Azure CLI: uruchom `az login` i wybierz właściwą subskrypcję: `az account set --subscription "<SUBSCRIPTION_NAME_OR_ID>"`.
- Zainstalowany Terraform (1.5+ zalecane) oraz dostępne provider-y pobierane przez `terraform init`.
- Uprawnienia Contributor we wskazanej subskrypcji.

## Parametryzacja

- `resource_group_name` – domyślnie `tf-lab1-rg`.
- `location` – domyślnie `West Europe`.
- `storage_account_prefix` – prefiks 3–11 znaków (małe litery/cyfry); rzeczywista nazwa konta = prefiks + losowy sufiks.

Przykład nadpisania zmiennych przy apply:

```bash
terraform apply -auto-approve \
    -var "resource_group_name=rg-demo" \
    -var "location=West Europe" \
    -var "storage_account_prefix=demosa"
```

Możesz też użyć pliku tfvars (np. `dev.tfvars`):

```bash
terraform plan -var-file="dev.tfvars"
terraform apply -auto-approve -var-file="dev.tfvars"
```

Albo przekazać wartości przez zmienne środowiskowe TF_VAR_*:

```bash
export TF_VAR_resource_group_name="rg-env"
export TF_VAR_location="West Europe"
export TF_VAR_storage_account_prefix="envsa"
terraform apply -auto-approve
```

## Pliki

*   `lab1/main.tf`
*   `lab1/variables.tf`
*   `lab1/outputs.tf`
*   `lab1/skrypt.sh`
