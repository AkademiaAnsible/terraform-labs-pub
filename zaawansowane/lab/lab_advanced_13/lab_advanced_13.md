# Lab Advanced 13: Logic App Standard z Private VNet Integration

## Cel laboratorium
- Przećwiczyć wdrożenie Logic App Standard (workflow as code).
- Skonfigurować Private Endpoint dla Storage Account.
- Zintegrować Logic App z siecią wirtualną (VNet Integration).
- Zastosować bezpieczną komunikację bez publicznych endpointów.

## Architektura
```
VNet (10.30.0.0/16)
  ├─ subnet-logic (10.30.1.0/24) - VNet Integration dla Logic App
  ├─ subnet-pe (10.30.2.0/24) - Private Endpoints
  └─ subnet-other (10.30.3.0/24) - przyszłe zasoby

Storage Account
  └─ Private Endpoint (blob, file, queue, table) → subnet-pe

Logic App Standard (App Service Plan)
  ├─ VNet Integration → subnet-logic
  └─ Komunikacja z Storage przez Private Endpoint
```

## Komponenty
- **VNet + subnety**: segmentacja ruchu.
- **Storage Account**: backend dla Logic App (stateful workflows).
- **Private Endpoint**: bezpieczna komunikacja z Storage.
- **Private DNS Zone**: rozwiązywanie nazw prywatnych.
- **App Service Plan (Workflow Standard)**: hosting Logic App.
- **Logic App Standard**: orkiestracja workflow.

## Krok po kroku

### 1. Przygotowanie struktury
```bash
cd zaawansowane/lab/lab_advanced_13
```

### 2. Konfiguracja zmiennych (`dev.tfvars`)
Dostosuj wartości (nazwy muszą być globalnie unikalne):
```hcl
resource_group_name = "rg-logicapp-dev"
storage_name        = "stlogicdev123"
logic_app_name      = "logic-workflow-dev"
```

### 3. Inicjalizacja i planowanie
```bash
terraform init -backend-config=backend.hcl
terraform validate
terraform plan -var-file=dev.tfvars
```

### 4. Wdrożenie
```bash
terraform apply -var-file=dev.tfvars -auto-approve
```

### 5. Weryfikacja Private Endpoint
- Sprawdź w Azure Portal → Storage Account → Networking:
  - Public access: Disabled
  - Private endpoints: aktywne
- Sprawdź Private DNS Zone: `privatelink.blob.core.windows.net`

### 6. Weryfikacja VNet Integration
- Azure Portal → Logic App → Networking → VNet Integration:
  - Powinien być podłączony do `subnet-logic`

### 7. Test workflow (opcjonalny)
W Azure Portal przejdź do Logic App → Workflows → utwórz prosty workflow testowy.

### 8. Cleanup
```bash
terraform destroy -var-file=dev.tfvars -auto-approve
```

## Wyjaśnienia

### Logic App Standard vs Consumption
| Cecha | Consumption | Standard (Workflow) |
|-------|-------------|---------------------|
| Hosting | Shared multi-tenant | Dedykowany App Service Plan |
| VNet Integration | Nie | Tak (pełna izolacja) |
| Workflow definition | Portal/ARM | Kod (VS Code, CI/CD) |
| Cena | Per execution | Plan + executions |

### Private Endpoint
Eliminuje publiczny dostęp do Storage Account. Ruch odbywa się przez Azure Backbone (prywatna sieć Microsoft).

### VNet Integration
Logic App może komunikować się z zasobami w sieci prywatnej (Storage, SQL, inne API wewnętrzne).

## Bezpieczeństwo
- Brak publicznych endpointów Storage.
- Komunikacja szyfrowana w ramach Azure Backbone.
- NSG na subnetach dla dodatkowej kontroli ruchu.
- Managed Identity dla Logic App (zamiast access keys).

## Typowe problemy
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| Logic App nie może połączyć się ze Storage | Brak delegacji subnetu | Dodaj `delegation { name = "Microsoft.Web/serverFarms" }` |
| DNS nie rozwiązuje privatelink | Brak VNet link w Private DNS Zone | Terraform automatycznie tworzy link |
| 403 Forbidden na Storage | Brak roli dla Managed Identity | Nadaj `Storage Blob Data Contributor` |

## Dobre praktyki
- Używaj Managed Identity zamiast access keys.
- Rozdziel subnety: VNet Integration / Private Endpoints / compute.
- Taguj zasoby (Environment, Project, Owner).
- Włącz diagnostics do Log Analytics.

## Rozszerzenia (dla zaawansowanych)
- Dodaj NSG z regułami dla subnet-logic.
- Skonfiguruj Azure Monitor dla workflow metrics.
- Wdroż drugi Logic App i przetestuj komunikację między nimi.
- Dodaj API Management przed Logic App.

## Efekt końcowy
- Logic App Standard z pełną izolacją sieciową.
- Bezpieczna komunikacja przez Private Endpoints.
- Gotowa infrastruktura do workflow as code w CI/CD.
