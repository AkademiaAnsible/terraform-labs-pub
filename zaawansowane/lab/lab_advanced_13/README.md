# Lab Advanced 13: Logic App Standard z Private VNet Integration

Laboratorium prezentujące zaawansowaną integrację Logic App Standard z siecią wirtualną i Private Endpoints.

## Architektura
- **VNet** z dedykowanymi subnetami (VNet Integration, Private Endpoints, inne)
- **Storage Account** z Private Endpoints (blob, file, queue, table)
- **Private DNS Zones** dla rozwiązywania nazw prywatnych
- **App Service Plan** (Workflow Standard WS1)
- **Logic App Standard** z VNet Integration i Managed Identity

## Bezpieczeństwo
✅ Brak publicznego dostępu do Storage  
✅ Komunikacja przez Azure Backbone (prywatna sieć)  
✅ Managed Identity zamiast access keys  
✅ TLS 1.2 minimum  
✅ FTPS wyłączony  

## Szybki start

### 1. Przygotowanie backendu
```bash
cp backend.hcl.example backend.hcl
# Edytuj backend.hcl i dostosuj parametry
```

### 2. Dostosowanie zmiennych
Otwórz `dev.tfvars` i zmień:
- `storage_name` - musi być globalnie unikalny (dodaj swoje inicjały)
- `logic_app_name` - dostosuj do konwencji nazewniczej

### 3. Uruchomienie skryptu automatycznego
```bash
./skrypt.sh
```

Lub krok po kroku:
```bash
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

### 4. Weryfikacja
Po wdrożeniu sprawdź:
```bash
# Outputs
terraform output

# Azure Portal
az logic workflow list --resource-group rg-logicapp-dev --output table
az network private-endpoint list --resource-group rg-logicapp-dev --output table
```

### 5. Cleanup
```bash
terraform destroy -var-file=dev.tfvars -auto-approve
```

## Struktura plików
```
lab_advanced_13/
├── main.tf              # Główna konfiguracja zasobów
├── variables.tf         # Definicje zmiennych
├── outputs.tf           # Wyniki wdrożenia
├── dev.tfvars           # Wartości dla środowiska dev
├── backend.tf           # Konfiguracja backendu
├── backend.hcl.example  # Przykład konfiguracji backendu
├── skrypt.sh            # Automatyzacja kroków
├── lab_advanced_13.md   # Szczegółowa dokumentacja
└── README.md            # Ten plik
```

## Komponenty

### Network
- **VNet**: 10.30.0.0/16
- **subnet-logic**: 10.30.1.0/24 (delegacja Microsoft.Web/serverFarms)
- **subnet-pe**: 10.30.2.0/24 (Private Endpoints)
- **subnet-other**: 10.30.3.0/24 (przyszłe zasoby)

### Storage
- **Account tier**: Standard
- **Replication**: LRS
- **Public access**: Disabled (gdy PE włączony)
- **Private Endpoints**: blob, file, queue, table

### Logic App
- **Plan**: WS1 (1 core, 3.5 GB RAM)
- **Runtime**: Node.js 18
- **Identity**: System Assigned Managed Identity
- **VNet Integration**: subnet-logic
- **Version**: ~4

## Koszty (orientacyjnie dla WS1 + Storage)
- **App Service Plan WS1**: ~$200/miesiąc (pay-as-you-go)
- **Storage LRS**: ~$0.02/GB/miesiąc
- **Private Endpoints**: ~$7/miesiąc za endpoint
- **Bandwidth**: wg zużycia

💡 Dla dev środowiska można zmienić SKU na mniejsze lub używać tylko podczas testów.

## Rozszerzenia
- Dodaj NSG z regułami dla subnet-logic
- Skonfiguruj Log Analytics + Application Insights
- Dodaj drugi Logic App i przetestuj komunikację
- Wdroż workflow through VS Code (workflow.json)
- Integracja z Azure DevOps/GitHub Actions

## Typowe problemy

### Logic App nie łączy się ze Storage
**Przyczyna**: Delegacja subnetu lub DNS Zone link  
**Rozwiązanie**: Sprawdź `delegation` w subnet-logic i VNet link w DNS Zone

### 403 Forbidden
**Przyczyna**: Brak roli dla Managed Identity  
**Rozwiązanie**: Nadaj rolę `Storage Blob Data Contributor` na Storage Account

### DNS nie rozwiązuje privatelink
**Przyczyna**: Brak linku DNS Zone do VNet  
**Rozwiązanie**: Terraform automatycznie tworzy - sprawdź `azurerm_private_dns_zone_virtual_network_link`

## Dokumentacja
Szczegóły w [lab_advanced_13.md](lab_advanced_13.md)

## Wymagania
- Terraform >= 1.13.0
- AzureRM provider ~> 3.99
- Azure CLI
- Subskrypcja Azure z uprawnieniami Contributor
