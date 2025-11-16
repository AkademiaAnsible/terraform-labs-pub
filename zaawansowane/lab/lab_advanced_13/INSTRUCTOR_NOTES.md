# Lab Advanced 13 - Notatki dla prowadzącego

## Kontekst
Laboratorium dodatkowe (poza główną ścieżką 1-12) prezentujące zaawansowaną integrację sieciową Logic App Standard.

## Cel edukacyjny
- Zrozumienie różnicy Logic App Consumption vs Standard (Workflow)
- Praktyka Private Endpoints dla Storage Account
- VNet Integration dla App Service / Logic App
- Private DNS Zones i automatyczne rozwiązywanie nazw
- Managed Identity zamiast access keys

## Czas realizacji
**60-90 minut** (zależnie od tempa grupy i czy tylko demo vs hands-on)

## Kiedy używać w szkoleniu?
- **Opcja 1**: Dzień 3 po lab_advanced_12 jako rozszerzenie złożonych środowisk
- **Opcja 2**: Demo podczas omówienia bezpieczeństwa sieciowego (Rozdział 9/10)
- **Opcja 3**: Samodzielna praca domowa dla ambitnych uczestników

## Przygotowanie (T-1)
1. Upewnij się, że subskrypcja wspiera SKU WS1 (Workflow Standard)
2. Sprawdź limity Private Endpoints per subscription
3. Przygotuj pre-deploy jeśli chcesz tylko pokazać działające środowisko (długi czas wdrożenia ~15-20 min)

## Kluczowe punkty do podkreślenia

### 1. Logic App Consumption vs Standard
| Aspekt | Consumption | Standard |
|--------|-------------|----------|
| Hosting | Multi-tenant shared | Dedykowany App Service Plan |
| VNet | Brak | Pełna integracja |
| Cena | Per execution | Plan + execution |
| Workflow | Portal/ARM | Code (CI/CD friendly) |

**DEMO**: Pokaż różnicę w Azure Portal między oboma typami.

### 2. Private Endpoint mechanizm
- Eliminuje publiczny dostęp (bezpieczeństwo)
- Ruch przez Azure Backbone (nie przez Internet)
- Wymagana Private DNS Zone dla rozwiązywania nazw

**UWAGA**: Częsty błąd - brak DNS Zone link do VNet → brak rozwiązywania nazw.

### 3. VNet Integration
- Subnet MUSI mieć delegację `Microsoft.Web/serverFarms`
- Logic App może łączyć się z zasobami w VNet
- Route all traffic przez VNet (ustawienie `vnet_route_all_enabled`)

**PUŁAPKA**: Bez delegacji subnet - błąd podczas integracji.

### 4. Managed Identity
- System Assigned tworzona automatycznie
- Używać zamiast Storage Account access keys
- Nadać rolę `Storage Blob Data Contributor`

**BEZPIECZEŃSTWO**: Nigdy nie eksportuj access keys w outputs / logs.

## Przebieg demonstracji (30 min demo)

### Segment 1: Wprowadzenie (5 min)
- Omów scenariusz: aplikacja workflow z izolacją sieciową
- Pokaż diagram architektury (VNet + subnety + PE)

### Segment 2: Kod Terraform (10 min)
```bash
# Live coding / code review
code main.tf
```
Podkreśl:
- Delegacja subnet-logic
- Conditional resources (count = var.enable_private_endpoint ? 1 : 0)
- Private DNS Zone + VNet link
- Private Endpoint dla każdego typu Storage (blob/file/queue/table)

### Segment 3: Wdrożenie (10 min)
```bash
cd lab_advanced_13
terraform init -backend-config=backend.hcl
terraform plan -var-file=dev.tfvars
# Jeśli pre-deploy: terraform apply -auto-approve
```

**TIMING**: Apply trwa ~12-15 min → użyj pre-deploy lub przerwij dla Q&A.

### Segment 4: Weryfikacja (5 min)
- Azure Portal → Storage Account → Networking (pokaż Disabled public access)
- Private Endpoints lista
- Logic App → Networking → VNet Integration status
- Private DNS Zones → A records

## Pytania kontrolne
1. **"Dlaczego Logic App Standard zamiast Consumption dla VNet?"**  
   → Standard ma dedykowany plan, pełna kontrola sieciowa.

2. **"Co się stanie jeśli usuniemy Private DNS Zone link?"**  
   → Logic App nie rozwiąże nazwy Storage privatelink → błąd połączenia.

3. **"Czy można użyć tego samego subnetu dla VNet Integration i Private Endpoints?"**  
   → Nie zalecane - separation of concerns, lepiej osobne subnety.

## Typowe problemy uczestników
| Problem | Objaw | Rozwiązanie |
|---------|-------|-------------|
| Długi czas apply | Terraform "wisi" | Normalny - PE + DNS ~10-15 min |
| 403 na Storage po deploy | Brak dostępu | Nadaj rolę Managed Identity (nie w Terraform base) |
| DNS nie działa | privatelink nie rozwiązuje | Sprawdź VNet link w DNS Zone |
| Subnet delegation error | Błąd integracji | Dodaj delegation w subnet |

## Rozszerzenia (dla zaawansowanych grup)
1. **NSG**: Dodaj Network Security Group z regułami dla subnet-logic
2. **Monitoring**: Dodaj Application Insights + diagnostics
3. **Workflow deployment**: Wdroż przykładowy workflow.json przez CLI
4. **API Management**: Postaw APIM przed Logic App
5. **Multi-region**: Rozszerz do Traffic Manager + 2 regiony

## Koszty (orientacyjne)
- WS1 Plan: ~$200/m (można zatrzymać po ćwiczeniu)
- Storage LRS: ~$2-5/m
- Private Endpoints (4x): ~$28/m
- DNS Zones (4x): ~$2/m
**TOTAL dev**: ~$50-70 za tydzień testów (stop plan poza godzinami)

## Cleanup
```bash
terraform destroy -var-file=dev.tfvars -auto-approve
```
Czas: ~8-10 min

## Linki referencyjne
- [Logic App Standard docs](https://learn.microsoft.com/azure/logic-apps/single-tenant-overview-compare)
- [Private Endpoints overview](https://learn.microsoft.com/azure/private-link/private-endpoint-overview)
- [VNet Integration App Service](https://learn.microsoft.com/azure/app-service/overview-vnet-integration)

## Feedback loop
Po laboratorium zapytaj:
- "Czy scenariusz VNet Integration jest jasny?"
- "Jakie use-cases macie w organizacji dla private networking?"
- Zbierz pytania o NSG, Firewall, routing customowy

---
**Uwaga końcowa**: Lab dodatkowy - nie wymuszaj jeśli czas ciasny. Można pominąć lub zadać jako homework.
