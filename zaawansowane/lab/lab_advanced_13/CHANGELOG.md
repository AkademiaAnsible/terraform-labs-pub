# Changelog - Lab Advanced 13

## [1.0.0] - 2025-11-16

### Dodano
- **Główna konfiguracja** (`main.tf`):
  - Virtual Network z 3 subnetami (logic, pe, other)
  - Delegacja subnetu dla Microsoft.Web/serverFarms
  - Storage Account z opcjonalnym wyłączeniem publicznego dostępu
  - 4 Private Endpoints (blob, file, queue, table)
  - 4 Private DNS Zones z linkami do VNet
  - App Service Plan (SKU WS1/WS2/WS3)
  - Logic App Standard z Managed Identity
  - VNet Integration dla Logic App

- **Zmienne** (`variables.tf`):
  - Walidacja nazwy Storage Account (lowercase, 3-24 chars)
  - Walidacja SKU App Service Plan (tylko WS1/WS2/WS3)
  - Opcjonalne flagi: enable_private_endpoint, enable_vnet_integration
  - Configurowalne prefiksy subnetów

- **Outputs** (`outputs.tf`):
  - Resource Group name
  - VNet ID
  - Storage Account name i endpoints
  - Logic App name, hostname, Managed Identity Principal ID
  - Private Endpoint IPs
  - Subnet IDs

- **Konfiguracja środowiska**:
  - `dev.tfvars` - przykładowe wartości dla środowiska dev
  - `backend.tf` + `backend.hcl.example` - konfiguracja zdalnego backendu

- **Dokumentacja**:
  - `lab_advanced_13.md` - szczegółowa instrukcja laboratorium
  - `README.md` - szybki start i struktura
  - `INSTRUCTOR_NOTES.md` - notatki dla prowadzącego szkolenie

- **Automatyzacja**:
  - `skrypt.sh` - skrypt pomocniczy do inicjalizacji i walidacji

- **Przykłady**:
  - `example-workflow.json` - prosty workflow Logic App
  - `test/logic_app_test.go` - przykładowe testy Terratest (koncepcyjne)

### Funkcjonalności
- ✅ Pełna izolacja sieciowa Logic App
- ✅ Bezpieczna komunikacja ze Storage przez Private Endpoints
- ✅ VNet Integration dla dostępu do zasobów prywatnych
- ✅ Managed Identity zamiast access keys
- ✅ Private DNS Zones dla automatycznego rozwiązywania nazw
- ✅ Walidacje na poziomie zmiennych
- ✅ Conditional resources (PE można wyłączyć)

### Bezpieczeństwo
- TLS 1.2 minimum dla Storage i Logic App
- FTPS wyłączony
- Public network access kontrolowany przez flagę
- Managed Identity dla autoryzacji
- Network rules Deny jako default (gdy PE włączony)

### Architektura
```
VNet 10.30.0.0/16
├─ subnet-logic (10.30.1.0/24) - delegacja Microsoft.Web/serverFarms
├─ subnet-pe (10.30.2.0/24) - Private Endpoints
└─ subnet-other (10.30.3.0/24) - rezerwa

Storage Account → 4x Private Endpoint → Private DNS Zones
Logic App → VNet Integration → subnet-logic
```

### Wymagania
- Terraform >= 1.13.0
- AzureRM provider ~> 3.99
- Azure CLI
- Subskrypcja z uprawnieniami do tworzenia Private Endpoints

### Koszty (orientacyjne dla dev)
- App Service Plan WS1: ~$200/m (można stopować)
- Storage LRS: ~$2-5/m
- Private Endpoints (4x): ~$28/m
- Private DNS Zones (4x): ~$2/m

### Znane ograniczenia
- Private Endpoints wymagają dedykowanego subnetu
- VNet Integration wymaga delegacji subnetu
- Logic App Standard nie wspiera Consumption planu
- Czas wdrożenia: 12-15 minut (Private Endpoints)

### Roadmap (przyszłe wersje)
- [ ] Dodanie NSG z przykładowymi regułami
- [ ] Integracja z Application Insights
- [ ] Przykładowy workflow z połączeniem do API
- [ ] Moduł Terraform dla Logic App
- [ ] Diagram architektury (Mermaid/ASCII)
