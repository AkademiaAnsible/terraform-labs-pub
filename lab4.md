# Lab 4: Użycie modułów i pętli `for_each`

## Cel

Celem tego laboratorium jest refaktoryzacja kodu z poprzednich laboratoriów do postaci modułu. Nauczymy się, jak tworzyć i używać reużywalne moduły oraz jak dynamicznie tworzyć wiele instancji zasobów za pomocą pętli `for_each`.

## Kroki

1.  **Przejrzyj strukturę plików:**
    *   `lab4/modules/storage`: Nowy folder zawierający definicję naszego modułu.
        *   `main.tf`, `variables.tf`, `outputs.tf`: Pliki te definiują, jakie zasoby tworzy moduł, jakie przyjmuje parametry i co zwraca.
    *   `lab4/main.tf`: Główny plik konfiguracyjny, który teraz wywołuje moduł `storage`. Zwróć uwagę na użycie `for_each` do utworzenia dwóch grup zasobów i kont magazynu.
    *   `lab4/variables.tf`: Definiuje mapę obiektów, która posłuży jako dane wejściowe dla pętli `for_each`.

2.  **Zainicjuj Terraform:**
    *   Uruchom `terraform init`. Terraform pobierze dostawcę `azurerm` oraz zainicjuje lokalne moduły.

3.  **Sprawdź plan i wdróż zasoby:**
    *   Uruchom `terraform plan`. Zobaczysz, że Terraform planuje utworzyć dwie grupy zasobów i dwa konta magazynu, zgodnie z definicją w mapie `environments`.
    *   Uruchom `terraform apply`, aby wdrożyć zasoby.

4.  **Przeanalizuj kod:**
    *   Zwróć uwagę, jak `for_each` iteruje po mapie `environments`. Klucz (`dev`, `prod`) i wartość (obiekt z atrybutami) są dostępne wewnątrz bloku `module` jako `each.key` i `each.value`.
    *   Zobacz, jak parametry są przekazywane do modułu i jak moduł zwraca wartości wyjściowe.

5.  **Posprzątaj zasoby:**
    *   Uruchom `terraform destroy`.

## Pliki

*   `lab4/main.tf`
*   `lab4/variables.tf`
*   `lab4/outputs.tf`
*   `lab4/modules/storage/main.tf`
*   `lab4/modules/storage/variables.tf`
*   `lab4/modules/storage/outputs.tf`
*   `lab4/skrypt.sh`

## Przykłady użycia

Aby ułatwić sobie pracę z różnymi środowiskami, możemy skorzystać z plików zmiennych oraz zmiennych środowiskowych.

### Użycie pliku zmiennych

Możemy stworzyć plik `lab4/dev.tfvars` z następującą zawartością:

```hcl
environments = {
  dev = {
    location            = "East US"
    resource_group_name = "rg-dev"
    storage_account_name = "devstorageacct"
  }
}
```

Następnie, aby zastosować te zmienne, uruchamiamy:

```bash
terraform apply -var-file="lab4/dev.tfvars"
```

### Użycie zmiennych środowiskowych

Możemy również ustawić zmienne środowiskowe w systemie operacyjnym. Na przykład, w systemie Linux lub macOS, możemy to zrobić w następujący sposób:

```bash
export TF_VAR_location="East US"
export TF_VAR_resource_group_name="rg-dev"
export TF_VAR_storage_account_name="devstorageacct"
```

Następnie uruchamiamy `terraform apply`, a Terraform automatycznie użyje tych zmiennych.
