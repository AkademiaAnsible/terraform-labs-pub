# Lab 10: Maszyna Wirtualna z podmontowanym Azure Files i przykładowym blobem

## Cel
Utworzyć maszynę wirtualną Linux w Azure, przygotować Storage Account z:
- udziałem Azure Files (SMB),
- kontenerem blob i przykładowym plikiem,
następnie zamontować udział na VM przy starcie za pomocą `cloud-init`. Lab pokazuje:
- użycie `custom_data` / `cloud-init`,
- bezpieczne przekazywanie klucza (uwaga na ekspozycję w stanie!),
- strukturę sieci (VNet + subnet + public IP + NIC),
- tagowanie i konsekwencje kosztowe.

## Wymagane elementy
Zasoby: `azurerm_resource_group`, `azurerm_virtual_network`, `azurerm_subnet`, `azurerm_public_ip`, `azurerm_network_interface`, `azurerm_storage_account`, `azurerm_storage_share`, `azurerm_storage_container`, `azurerm_storage_blob`, `azurerm_linux_virtual_machine`.

## Kroki
1. Inicjalizacja: `terraform init`.
2. `terraform plan` – zobacz tworzenie: RG, VNet, subnet, SA, File Share, Container, Blob, VM.
3. `terraform apply` – wdrożenie infrastruktury.
4. Po utworzeniu – zaloguj się przez SSH: `ssh azureuser@<public_ip>`.
5. Sprawdź montowanie udziału: `df -h | grep azfiles` lub `ls /mnt/azfiles`.
6. Zweryfikuj obecność pliku blob (jeśli przesyłany np. `sample.txt`).

## Przykładowy fragment `cloud-init` (skrót)
```yaml
#cloud-config
runcmd:
  - mkdir -p /mnt/azfiles
  - echo "//${SA_NAME}.file.core.windows.net/${FILE_SHARE} /mnt/azfiles cifs vers=3.1.1,username=${SA_NAME},password=${SA_KEY},serverino" >> /etc/fstab
  - mount -a
```
W Terraform generowane np. przez:
```hcl
custom_data = base64encode(templatefile("${path.module}/scripts/cloud-init.yaml", {
  sa_name  = azurerm_storage_account.sa.name
  share    = azurerm_storage_share.files.name
  sa_key   = azurerm_storage_account.sa.primary_access_key
}))
```

## Weryfikacja
- VM ma poprawny status `Succeeded`.
- Udział Azure Files zamontowany (widoczne w `df -h`).
- Plik/testowy w udziale dostępny z poziomu VM.
- Blob istnieje w kontenerze (`az storage blob list`).

## Dobre praktyki
- Unikaj przechowywania `primary_access_key` w jawnym `custom_data` – rozważ Managed Identity + `Azure Files Identity` (gdy dostępne) lub rotację kluczy.
- Ogranicz dostęp sieciowy (NSG / Private Endpoint dla Storage, docelowo wyłączenie public access jeśli możliwe).
- Taguj zasoby (`Environment`, `Owner`, `CostCenter`).
- Minimalizuj rozmiar VM dla labów (np. `Standard_B1s/B2s`).

## Rozszerzenia
- Dodaj `azurerm_network_security_group` i powiązanie z subnetem.
- Skonfiguruj Private Endpoint dla Storage i aktualizuj fstab (bez public endpointów).
- Zastąp klucz – użyj Workload Identity + SAS na poziomie katalogu (tylko gdy konieczne).
- Dodaj diagnostykę do Log Analytics (integracja z Lab 12).

## Typowe błędy
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| Brak montowania | Błędny wpis w fstab / brak pakietu cifs-utils | Dodaj instalację pakietu w cloud-init (`apt-get update && apt-get install -y cifs-utils`). |
| Permission denied | Niewłaściwy klucz / rotacja | Odśwież klucz w stanie lub użyj MSI jeśli obsługiwane. |
| Wolne I/O | Udział Standard + mała przepustowość | Testowo zwiększ SKU Storage lub użyj Premium Files. |
| Ekspozycja klucza | Klucz w stanie/planie | Przenieś do zmiennej środowiskowej lub użyj alternatywnego uwierzytelnienia. |

## Sprzątanie
`terraform destroy` – usunie VM, sieć, Storage (uwaga: utrata danych w udziale i blobach). Jeśli chcesz zachować dane – usuń najpierw VM/NIC/PIP lecz pozostaw Storage.

## Checklist końcowa
- [ ] VM utworzona
- [ ] Udział zamontowany
- [ ] Blob widoczny
- [ ] Klucz nie wyciekł do repo

## Następny krok
Przejdź do Lab 11 (backend zdalny) lub Lab 12 (Log Analytics) aby rozszerzyć obserwowalność i współdzielenie.
