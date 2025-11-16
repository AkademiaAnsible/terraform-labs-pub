# Skrypt prowadzącego – Zaawansowane szkolenie Terraform na Azure (3 dni)

> Ten dokument to szczegółowy scenariusz (runbook) prowadzenia szkolenia. Zawiera: cele, kluczowe komunikaty, strukturę wypowiedzi, demonstracje krok‑po‑kroku, pytania kontrolne, pułapki, warianty przyspieszeń/zwolnień oraz podsumowania segmentów.

## Konwencje
- "SLIDE" – sugerowany slajd / temat.
- "DEMO" – demonstracja live w terminalu / VS Code.
- "PYTANIE" – pytanie do grupy.
- "UWAGA" – podkreślenie krytycznej praktyki lub ryzyka.
- Czas w nawiasach można skalować (±5–10 min) zależnie od tempa grupy.

## Przed szkoleniem (T‑0)
1. Zweryfikuj dostęp do subskrypcji (rola Contributor lub granularne RBAC do zasobów ćwiczeń).
2. Sprawdź wersje: `terraform -v` (zalecane >=1.13.x – jeśli 1.14.x beta, wspomnij o bulk import). AzureRM provider ~>3.x lub najnowszy stabilny.
3. Ustaw środowisko: VS Code + rozszerzenia (Terraform, YAML), Azure CLI zalogowane (`az login`).
4. Eksportuj: `echo $ARM_SUBSCRIPTION_ID` – brak? Poproś o ustawienie lub wybór kontekstu `az account set --subscription ...`.
5. Przygotuj repo lokalne (branch `main`, zainicjalizowany backend dla wybranych labów jeśli potrzebne). 

## Dzień 1 – Moduły, Backendy, Import, Rozwój

### 09:00–10:30 Wprowadzenie / środowisko
SLIDE: Cele szkolenia + mapa 3 dni.
Cele segmentu:
- Ustalenie poziomu grupy.
- Sprawdzenie dostępu do narzędzi.
- Ujednolicenie terminologii (moduł, backend, stan).

Kluczowe punkty:
- Terraform: deklaratywny graf zależności.
- Root module vs child modules (hierarchia – doc: Modules overview / hierarchy).
- State = źródło prawdy; nie commitować.

DEMO (skrót):
```bash
terraform init
terraform plan
```
Pokaz minimalnego pliku `main.tf` z 1 RG.

PYTANIE: "Kto z Was używał już zdalnego backendu?" – sondowanie.

Pułapki:
- Lokalny stan na kilku laptopach → diverging state.
- Brak wersjonowania providerów.

Zarządzanie czasem: jeśli grupa szybka – zapowiedz wcześniejsze wejście w moduły.
Transition: "Skoro mamy środowisko, przejdźmy do sposobu skalowania konfiguracji przez moduły i meta‑argumenty." 

### 10:40–13:00 Modularność + count/for_each/dynamic
SLIDE: Różnice count vs for_each.

Cele:
- Umieć dobrać count vs for_each (dokument: for_each reference / how to choose).
- Zrozumieć ograniczenia: klucze muszą być znane przed apply (for_each limitations).
- Stosować dynamic block odpowiedzialnie (best practices – unikać overuse).

Struktura wypowiedzi:
1. Dlaczego moduły? Standaryzacja, reużywalność, audyt.
2. Hierarchia: root module → child modules (sources: lokalny, registry, VCS).
3. Meta‑argumenty: count (homogeniczność), for_each (heterogeniczność, stabilne adresy). 
4. dynamic: generuje zagnieżdżone bloki (np. service_endpoints, ip_rules) – tylko gdy liczności różne / opcjonalność.

DEMO 1 – for_each prosty:
```hcl
resource "azurerm_resource_group" "rg" {
  for_each = tomap({ dev = "westeurope", prod = "northeurope" })
  name     = "demo-${each.key}-rg"
  location = each.value
}
```
Plan -> pokaż adresowanie `azurerm_resource_group.rg["dev"]`.

DEMO 2 – chaining for_each (doc: chain for_each between resources): utworzenie Storage + Container per RG.

DEMO 3 – dynamic block:
Zmienna `allowed_ips = ["1.2.3.4"]` → generacja ip_rules.

PYTANIA kontrolne:
- "Kiedy for_each zamiast count?" (Różne parametry niedające się wyliczyć z indeksu).
- "Czy można użyć sensitive wartości jako kluczy?" (Nie – for_each limitations).

Anti‑patterny do podkreślenia:
- dynamic wszędzie zamiast jawnych bloków.
- Moduł będący cienką nakładką na jeden zasób (wartość dodana?).

Ćwiczenie (uczestnicy): refaktoryzacja istniejącej konfiguracji z powtarzalnymi subnetami na for_each + dynamic service endpoints.

Fallback (wolniejsze tempo): pokaż tylko for_each + mapping RG.
Accel (szybkie tempo): wprowadź ephemeral resources koncept (przytocz krótko – random_password ephemeral z doc), z zastrzeżeniem wersji.

Transition: "Mamy narzędzia skalowania. Teraz zadbajmy o współdzielony stan – zdalny backend." 

### 13:40–14:40 Remote backends (Azure Storage)
SLIDE: Dlaczego zdalny backend?
Cele:
- Znać metody autoryzacji backendu azurerm (OpenID Connect, MSI, CLI, Access Key, SAS – doc: azurerm backend Authentication).
- Rekomendacja: OIDC / Managed Identity (avoid Access Key/SAS – legacy).
- Least privilege: Storage Blob Data Contributor + (opcjonalnie) Reader jeśli lookup.

DEMO – minimalny backend (Azure CLI logged in):
```hcl
terraform {
  backend "azurerm" {
    use_cli              = true
    use_azuread_auth     = true
    storage_account_name = "<sa>"
    container_name       = "tfstate"
    key                  = "env1.tfstate"
  }
}
```
`terraform init` z `-backend-config` przekazaniem wartości – podkreśl unikanie twardych sekretów.

UWAGI bezpieczeństwa:
- Nie wstawiać access_key w kodzie – doc ostrzeżenie (Credentials and Sensitive Data).
- OIDC w GitHub / Azure DevOps – pokaż przykładowy fragment z doc (use_oidc + tenant_id + client_id + key). 

PYTANIE: "Która metoda autoryzacji wymaga najmniejszej rotacji tajnych wartości?" (OIDC / workload identity federacja).

Troubleshooting checklista:
- Błąd 403 – brak roli Blob Data Contributor.
- Niepoprawny tenant_id vs login – sprawdź `az account show`.

Transition: "Stan zabezpieczony – co jeśli mamy istniejącą infrastrukturę? Import." 

### 14:40–15:40 Repozytorium modułów / publikacja
SLIDE: Cykl życia modułu (Develop → Publish → Consume – doc workflows modules).
Cele:
- Struktura modułu (main.tf, variables.tf, outputs.tf, README, examples).
- Wersjonowanie semver, tagi Git.
- Standardy: opis wejść/wyjść, testy (Terratest / static analysis).

DEMO: Utworzenie prostego modułu `modules/network` i użycie w root.
Pokaż `version = "~> 1.0"` gdyby to był registry.

Checklist modułu:
1. Dokumentacja.
2. Inputs – typy + opisy + walidacje.
3. Outputs – bez wrażliwych danych jeśli możliwe.
4. Tag release.

PYTANIE: "Kiedy lepiej NIE tworzyć modułu?" (Gdy brak abstrakcji – niemal 1:1 z zasobem bez wartości dodanej).

Transition: "Mamy moduły, czas na pogłębienie – złożone outputs, walidacje, testy." 

### 15:50–16:50 Pogłębienie modułów
SLIDE: locals / outputs / composition.
Cele:
- Kompozycja zamiast głębokiego zagnieżdżania.
- Walidacje (`variable { validation { condition ... } }`).
- Moved blocks do refaktoryzacji (wspomnij – zachowanie stanu).

DEMO: Dodanie `locals { name_prefix = "${var.project}-${var.env}" }` → użycie w zasobach.
DEMO: Walidacja `var.env in ["dev", "prod"]`.

Pułapki:
- Nadmierne przekazywanie całych map bez agregacji.
- Brak testów → dryft jakości.

PYTANIE: "Jak wykryć że moduł jest zbyt ogólny?" (Wiele zmiennych 1:1 odwzorowujących bloki zasobu).

Podsumowanie dnia: powtórzenie: moduły, meta‑argumenty, backend, publikacja.
Zadanie domowe (opcjonalne): przenieść istniejący zestaw zasobów do modułu + README.

## Dzień 2 – Zmienne, Walidacja, CI/CD, Bezpieczeństwo

### 09:00–10:30 Zaawansowane typy / datasources + Import
SLIDE: Typy kolekcji i obiekty.
Cele:
- Precyzyjne typowanie (`map(object({...}))`, `set(string)` dla for_each).
- Locals do uproszczeń i agregacji.
- Datasources – kiedy tak, kiedy parametryzacja.
- Import workflow (doc: Import existing resources overview – CLI vs import block).

DEMO: Zmienna `variable "subnets" { type = map(object({ cidr = string })) }` → for_each subnets.
DEMO: Import istniejącego RG: dodaj `resource "azurerm_resource_group" "legacy" { name="existing-rg" location="westeurope" }` → `terraform import azurerm_resource_group.legacy /subscriptions/.../resourceGroups/existing-rg`.

Uwagi import:
- Najpierw kod, potem import (doc podkreśla brak generowania kodu przez CLI).
- Po imporcie `plan` – rozbieżności = dopasowanie atrybutów.

PYTANIA:
- "Czy CLI import tworzy konfigurację?" (Nie).
- "Jak uniknąć importu duplikatów?" (Jeden obiekt → jeden adres stanu).

### 10:40–13:00 CI/CD i workflow PR
SLIDE: Etapy pipeline: fmt → validate → tflint/checkov → plan → manual approve → apply.
Cele:
- Egzekwowanie jakości i bezpieczeństwa przed apply.
- OIDC autoryzacja w pipeline (backend + provider).
- Oddzielenie planowania od wdrażania.

DEMO (fragment pliku workflow GitHub Actions):
```yaml
jobs:
  plan:
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      - name: Terraform Init
        run: terraform init -backend-config="storage_account_name=$SA" -backend-config="container_name=tfstate" -backend-config="key=prod.tfstate"
      - name: Terraform Plan
        run: terraform plan -out plan.bin
```
Podkreśl: brak sekretów, użycie OIDC (id-token: write).

PYTANIE: "Dlaczego nie commitujemy pliku plan.bin?" (Zawiera potencjalne dane wrażliwe + generowany artefakt ephemeral).

### 13:40–15:40 Standardy walidacji i bezpieczeństwa
SLIDE: Narzędzia: tflint, checkov, tfsec, pre-commit.
Cele:
- Minimalizacja błędów konfiguracyjnych (tagi, brak public IP).
- Wczesna walidacja naming & constraints.
- Audyt zmian.

DEMO: pre-commit YAML z hookami fmt + tflint.
DEMO: checkov skan `checkov -d .` – interpretacja wyniku (wysoki vs niski priorytet).

PYTANIE: "Które narzędzie wychwyci brak szyfrowania w Key Vault?" (checkov / tfsec policy).

### 15:50–17:00 HCP Terraform / Alternatywy (Terragrunt, Terramate)
SLIDE: Porównanie.
Cele:
- Zrozumieć kiedy narzędzie dodatkowe ma sens (duża liczba workspace / DRY / generacja katalogów).
- Główne korzyści i koszty adopcji.

Struktura:
1. HCP Terraform – remote runs, policy sets (Sentinel), private registry.
2. Terragrunt – warstwa DRY dla wielu stacków.
3. Terramate – generacja scaffold / orchestracja.

PYTANIE: "Co jest większym kosztem wejścia – Terragrunt czy HCP Terraform?" (Zależne od org – wskazówki).

Podsumowanie dnia: dane wejściowe, walidacje, bezpieczeństwo, automatyzacja.

## Dzień 3 – Standardy, Hardenowanie, Złożone środowiska

### 09:00–10:30 Standardy organizacyjne / validate
SLIDE: validate w zmiennych.
Cele:
- Wymuszanie naming konwencji.
- Odmowa wartości niezgodnych (np. zabroniony SKU).

DEMO: 
```hcl
variable "environment" {
  type = string
  validation {
    condition     = contains(["dev","test","prod"], var.environment)
    error_message = "environment must be one of dev|test|prod"
  }
}
```

PYTANIE: "Co walidujemy – dane czy logikę infrastruktury?" (Tylko dane wejściowe – logika w zasobach).

### 10:40–12:40 Hardenowanie / exclude wzorce
SLIDE: Hardenowanie przykład: wymuszony HTTPS CDN, brak access keys w kodzie.
Cele:
- Wbudowane zabezpieczenia w modułach (np. blokada tworzenia Storage bez TLS).
- Dokumentowanie wyjątków (komentarz + ticket ID).

DEMO: Module param `allow_public_access = false` → conditional w resource.
DEMO: Wymuszenie roli MSI dla backend (przykłady config doc – use_msi).

PYTANIE: "Dlaczego rotation secret vs OIDC?" (Mniej rotacji i brak statycznych sekretów w OIDC).

### 13:20–14:20 Narzędzia Terragrunt/Terramate (pogłębienie) – krótkie demo generacji.

### 14:20–16:20 Budowa złożonego środowiska (Case study)
SLIDE: Diagram architektury (AI services + KV + UAI + Storage + FunctionApp).
Cele:
- Integracja wielu modułów.
- Spójna polityka tagów i naming.
- Pipeline z plan/apply + manual approval.

Plan prowadzenia:
1. Start od definicji wspólnych `locals { tags = {...} }`.
2. Dodanie Key Vault → sekret → wykorzystanie w Function App setting (uwaga: secret w stanie jeśli bezpośrednio użyty).
3. Dodanie User Assigned Managed Identity i przypięcie do Function App.
4. Storage + Private Endpoint (uwaga koszt / czas – można pominąć jeśli mało czasu).
5. Deployment pipeline stub – tylko plan.

Pułapki:
- Kolejność zależności (Function App czeka na Identity). Rozwiązanie: implicit reference vs depends_on w razie potrzeby.
- Zbyt wiele równoczesnych zmian – małe kroki + częsty plan.

PYTANIE: "Który komponent w pierwszej kolejności hardenować?" (Najczęściej storage / klucze / sekrety – KV & identity).

Checklist końcowego środowiska:
- [ ] Moduły z wersjonowaniem.
- [ ] Backend OIDC / MSI.
- [ ] Key Vault + rotacja planowana.
- [ ] Tagowanie spójne.
- [ ] Pipeline plan+approve.

### 16:20–17:00 Q&A / Podsumowanie / Ankieta
SLIDE: Podsumowanie 3 dni: moduły, meta‑argumenty, backend, bezpieczeństwo, CI/CD, narzędzia.
Zadania follow‑up:
1. Wdrożyć OIDC w produkcyjnym pipeline.
2. Spisać standard naming & tagging.
3. Utworzyć katalog prywatnych modułów.

Ankieta: przypomnij `ankieta.md` / `ankieta.docx`.

## Segmentowe Pytania Kontrolne (ściągawka)
- Różnica count vs for_each? (Identyczne vs heterogeniczne instancje; stabilne adresy kluczy; for_each nie przyjmuje sensitive)
- Kiedy dynamic block? (Opcjonalne / zmienna liczba zagnieżdżonych bloków)
- Najbezpieczniejsza metoda autoryzacji backendu? (OIDC / workload identity federation)
- Co robi import CLI? (Tylko stan – nie generuje konfiguracji)
- Dlaczego nie trzymać access_key? (Rotacja, ryzyko wycieku; prefer OIDC/MSI)
- Jak walidować environment? (variable validation block)
- Hardenowanie – przykład? (Wymuszenie HTTPS, brak public access, brak access_key)

## Najczęstsze Pułapki i Reakcje
| Sygnał | Przyczyna | Reakcja prowadzącego |
|--------|----------|----------------------|
| Uczestnik powiela kod zamiast modułu | Brak zrozumienia wartości abstrakcji | Pokaż porównanie lines-of-code vs moduł + README |
| Błąd 403 przy backend init | Brak roli Blob Data Contributor | Wskaż wymagane role (least privilege) |
| Nieczytelna dynamic block kaskada | Nadmierne zagnieżdżenie | Wróć do jawnego zapisu bloków lub refaktoryzuj | 
| Hasła w output | Nieuwaga przy definicji output | Oznacz sensitive, usuń output; użyj Key Vault | 
| Plan proponuje rekreację wielu zasobów | Zmiana kluczy for_each | Omów stabilność kluczy; ewentualnie moved blocks |

## Timeboxing / Warianty
- Jeśli dzień 1 się opóźnia: skrócić część publikacji modułów, zostawić tylko lokalny moduł.
- Jeśli dzień 2 przyspiesza: rozszerzyć część CI/CD o policy sets / ephemeral resources.
- Jeśli dzień 3 przyspiesza: dodać demo terramate generujące katalogi środowisk.

## Troubleshooting Quick Reference
- Backend: `terraform init -reconfigure` przy zmianie parametrów.
- Import: użyj pełnego ID zasobu; jeśli provider żąda formatów – sprawdź dokumentację resource (sekcja Import). 
- Dynamic block debug: tymczasowo wypisz listę/mapę `terraform console`.
- OIDC w Actions: sprawdź `permissions: id-token: write`.
- Access denied Key Vault: rola `Key Vault Secrets User` / RBAC vs access policies.

## Wersje i Kompatybilność (notatka dla prowadzącego)
- Funkcje ephemeral (pokazane w dokumentacji) pojawiają się w nowszych wersjach – oznacz jako preview jeśli środowisko <1.13.
- Bulk import (1.14 beta) – wspomnij jako nadchodzące usprawnienie.
- Zawsze potwierdź aktualny changelog AzureRM (może dodać breaking changes w zasobach). 

## Skrypt słowny – przykładowe otwarcia segmentów
- Start dnia: "Dzisiaj skupimy się na skalowaniu konfiguracji za pomocą modułów i meta‑argumentów, aby ograniczyć powtarzalność i poprawić spójność."
- Przed backendem: "Mamy narzędzia tworzenia – przejdźmy do współdzielenia stanu bez kolizji."
- Przed importem: "Jeśli firma ma już zasoby – nie zaczynamy od zera: zmapujmy je do kodu."
- Przed CI/CD: "Manualny apply jest w porządku w labie, ale produkcja potrzebuje kontroli jakości i ścieżki audytu."
- Przed hardening: "Konfiguracja działa – teraz należy ją zabezpieczyć zgodnie z politykami organizacji."

## Zamknięcie szkolenia (ostatnie 10 minut)
1. Powtórzenie 3 kluczowych idei: Reużywalność (moduły), Przejrzystość (CI/CD + walidacje), Bezpieczeństwo (OIDC + hardening).
2. Wskazanie kolejnych kroków wdrożeniowych.
3. Wypełnienie ankiety.
4. Podziękowanie i kanał kontaktu (mail / Teams / GitHub Issues).

---
> Dokument można aktualizować inkrementalnie – zachowaj sekcję "Wersje i Kompatybilność" zgodną z bieżącymi zmianami Terraform.
