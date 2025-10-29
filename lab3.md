# Lab 3: Dodanie Log Analytics Workspace

## Cel

Celem tego laboratorium jest rozbudowa istniejącej infrastruktury o dodatkowy zasób - Log Analytics Workspace. Pozwoli to przećwiczyć modyfikowanie istniejącej konfiguracji Terraform.

## Kroki

1.  **Przejrzyj pliki konfiguracyjne:**
    *   `main.tf`: Został dodany nowy zasób `azurerm_log_analytics_workspace`.
    *   `variables.tf`: Dodano zmienną dla nazwy Log Analytics Workspace.
    *   `outputs.tf`: Dodano output dla ID nowo utworzonego workspace'u.
    *   `backend.tf`: Pozostaje bez zmian.

2.  **Zainicjuj Terraform:**
    *   Jeśli kontynuujesz po Lab 2 i masz już zainicjowany backend, ten krok nie jest konieczny. W przeciwnym razie uruchom `terraform init`.

3.  **Sprawdź plan i wdróż zmiany:**
    *   Uruchom `terraform plan`. Terraform powinien pokazać, że planuje dodać jeden nowy zasób (`azurerm_log_analytics_workspace`) i nie zamierza modyfikować ani usuwać istniejących.
    *   Uruchom `terraform apply`, aby wdrożyć zmianę.

4.  **Sprawdź wynik:**
    *   Po zakończeniu `apply`, sprawdź w portalu Azure, czy nowy Log Analytics Workspace został utworzony w tej samej grupie zasobów.

5.  **Posprzątaj zasoby:**
    *   Uruchom `terraform destroy`, aby usunąć wszystkie zasoby zarządzane przez tę konfigurację.

## Pliki

*   `lab3/main.tf`
*   `lab3/variables.tf`
*   `lab3/outputs.tf`
*   `lab3/backend.tf`
*   `lab3/skrypt.sh`

## Przykłady użycia

Aby ułatwić sobie pracę z Terraformem, można skorzystać z poniższych przykładów.

1.  **Użycie zmiennych środowiskowych TF_VAR\_\*:**

    Przykład użycia zmiennej środowiskowej dla nazwy Log Analytics Workspace:

    ```bash
    export TF_VAR_log_analytics_workspace_name="mojworkspace"
    ```

    Następnie można uruchomić `terraform apply`, a Terraform automatycznie użyje tej zmiennej.

2.  **Użycie pliku zmiennych -var-file:**

    Można również zdefiniować zmienne w pliku, na przykład `terraform.tfvars`:

    ```hcl
    log_analytics_workspace_name = "mojworkspace"
    ```

    Następnie podczas uruchamiania Terraformu użyj opcji `-var-file`:

    ```bash
    terraform apply -var-file="terraform.tfvars"
    ```
