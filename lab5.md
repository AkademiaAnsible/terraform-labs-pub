# Lab 5: Rozbudowa o Private Endpoint i VNet

## Cel

Celem tego laboratorium jest zabezpieczenie dostępu do konta magazynu poprzez dodanie sieci wirtualnej (VNet), podsieci (Subnet) oraz prywatnego punktu końcowego (Private Endpoint). To typowy scenariusz zapewniania bezpiecznej komunikacji między zasobami w Azure.

## Kroki

1.  **Przejrzyj pliki konfiguracyjne:**
    *   `lab5/networking.tf`: Nowy plik definiujący sieć VNet i podsieć. Zwróć uwagę na `enforce_private_link_endpoint_network_policies = true` w definicji podsieci.
    *   `lab5/main.tf`: Wywołanie modułu zostało rozszerzone o nowe parametry związane z siecią.
    *   `lab5/modules/storage/main.tf`: Moduł został rozbudowany o zasoby `azurerm_private_endpoint` i `azurerm_private_dns_zone_group`. Tworzy również kontener blob.
    *   `lab5/modules/storage/variables.tf`: Dodano nowe zmienne dla ID podsieci i nazwy kontenera.

2.  **Zainicjuj Terraform:**
    *   Uruchom `terraform init`.

3.  **Sprawdź plan i wdróż zasoby:**
    *   Uruchom `terraform plan`. Zobaczysz, że Terraform planuje utworzyć VNet, podsieć, Private Endpoint oraz inne powiązane zasoby (jak strefa Private DNS).
    *   Uruchom `terraform apply`.

4.  **Przeanalizuj kod:**
    *   Zobacz, jak `azurerm_private_endpoint` łączy konto magazynu z podsiecią.
    *   Zwróć uwagę na blok `private_dns_zone_group`, który jest niezbędny do poprawnego działania resolucji DNS dla prywatnego punktu końcowego.
    *   Przeanalizuj, jak dane (np. ID podsieci) są przekazywane z głównej konfiguracji do modułu.

5.  **Posprzątaj zasoby:**
    *   Uruchom `terraform destroy`.

## Pliki

*   `lab5/main.tf`
*   `lab5/networking.tf`
*   `lab5/variables.tf`
*   `lab5/outputs.tf`
*   `lab5/modules/storage/main.tf`
*   `lab5/modules/storage/variables.tf`
*   `lab5/modules/storage/outputs.tf`
*   `lab5/skrypt.sh`

## Przykłady użycia

Aby ułatwić pracę z różnymi konfiguracjami, możesz skorzystać z plików zmiennych (`-var-file`) lub zmiennych środowiskowych (`TF_VAR_*`).

### Użycie z plikiem zmiennych

Możesz utworzyć plik `lab5/terraform.tfvars` z zawartością:

```hcl
location = "East US"
resource_group_name = "myResourceGroup"
storage_account_name = "mystorageaccount"
container_name = "mycontainer"
vnet_name = "myVNet"
subnet_name = "mySubnet"
```

Następnie uruchom Terraform z tym plikiem:

```bash
terraform apply -var-file="lab5/terraform.tfvars"
```

### Użycie ze zmiennymi środowiskowymi

Alternatywnie, możesz ustawić zmienne środowiskowe w swoim systemie. Na przykład, w systemie Linux lub macOS:

```bash
export TF_VAR_location="East US"
export TF_VAR_resource_group_name="myResourceGroup"
export TF_VAR_storage_account_name="mystorageaccount"
export TF_VAR_container_name="mycontainer"
export TF_VAR_vnet_name="myVNet"
export TF_VAR_subnet_name="mySubnet"
```

Następnie uruchom Terraform:

```bash
terraform apply
```

Pamiętaj, aby dostosować wartości do swoich potrzeb.
