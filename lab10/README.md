# Lab 10 – Blob Storage + VM z montowaniem kontenera (blobfuse2)

Cel: Utworzyć Storage Account z prywatnym kontenerem blob oraz maszynę wirtualną Linux, która montuje kontener jako system plików przy starcie (cloud-init + blobfuse2 z SAS tokenem).

## Zawartość
- `main.tf` – zasoby: RG, VNet, Subnet, NSG (SSH), Storage Account, Container, SAS token, VM.
- `variables.tf` – parametry wejściowe (naming, region, sieć, mount).
- `scripts/cloud-init.yaml` – konfiguracja instalacji blobfuse2 i montowania kontenera.
- `dev.tfvars` – przykładowe wartości środowiskowe.
- `skrypt.sh` – pomocniczy skrypt uruchomieniowy.
- `outputs.tf` – kluczowe wartości wyjściowe.

## Kroki
1. (Opcjonalnie) Utwórz oddzielny RG i podaj nazwę w `resource_group_name` albo pozwól Terraform utworzyć.
2. Uruchom:
   ```bash
   cd lab10
   ./skrypt.sh
   ```
3. Po provisioning zaloguj się na VM (dopisz regułę SSH lub dodaj Public IP jeśli potrzebne – w tym labie używamy tylko prywatnego IP, możesz rozszerzyć o Public IP jeśli wymagasz zdalnego dostępu).
4. Sprawdź montowanie:
   ```bash
   ls -l /mnt/blobdata
   ```
5. Utwórz plik testowy lokalnie na VM i zweryfikuj widoczność w kontenerze blob (narzędzia az CLI / Portal).

## Uwagi bezpieczeństwa
- SAS token ważny 24h – po wygaśnięciu trzeba wygenerować nowy (ponowny `plan/apply`).
- W produkcji preferuj Managed Identity + rolę Storage Blob Data Reader/Contributor oraz autoryzację OAuth zamiast SAS.
- Montowanie blob przez blobfuse2 jest optymalne dla scenariuszy read/list; dla silnego zapisu rozważ Azure Files.

## Rozszerzenia
- Dodaj Private Endpoint dla Storage Account.
- Zastąp SAS autoryzacją z Managed Identity (blobfuse2 obsługuje MSI – wymaga innej konfiguracji w cloud-init).
- Dodaj diag settings i Log Analytics workspace.
- Dodaj reguły NSG ograniczające SSH do adresów firmowych.

## Czyszczenie
```bash
terraform destroy -var-file=dev.tfvars
```
