# Szczegółowe opisy zagadnień Terraform

Poniżej znajduje się szczegółowe omówienie każdego zagadnienia z listy szkoleniowej. Każdy punkt zawiera: definicję, zastosowanie, dobre praktyki, typowe błędy oraz przykłady (w miarę możliwości z kontekstem Azure). Wszystkie opisy są oryginalne i przygotowane w języku polskim.

---
## 01. Infrastructure as Code (IaC)
Infrastructure as Code (IaC) to paradygmat definiowania i zarządzania infrastrukturą IT (sieci, maszyny wirtualne, systemy operacyjne, load balancery, usługi PaaS, kontrola dostępu, reguły bezpieczeństwa) poprzez kod zamiast manualnych działań w interfejsach graficznych. KOD = PRAWDA ŹRÓDŁOWA. Każda zmiana powinna przejść przez repozytorium (Git), proces przeglądu (code review) oraz kontrolowany pipeline (CI/CD). 

### Dlaczego IaC powstało?
Tradycyjne, ręczne podejście (tzw. „click ops”) generowało problemy: brak spójności środowisk (DEV ≠ TEST ≠ PROD), trudność w odtworzeniu po awarii, brak audytowalności, uzależnienie od jednego administratora. IaC rozwiązuje te problemy poprzez:
1. Wersjonowanie – pełna historia decyzji architektonicznych (git log, pull requesty).
2. Idempotencję – wielokrotne wykonanie tej samej konfiguracji nie zmienia jej stanu, jeśli nie ma różnic.
3. Automatyzację – integracja z pipeline’ami (GitHub Actions / Azure DevOps) umożliwia szybkie, powtarzalne wdrożenia.
4. Audyt i zgodność – kod da się skanować pod kątem bezpieczeństwa (Security as Code, Policy as Code – np. Sentinel, OPA).

### Style IaC
- Deklaratywny: opisujesz „CO” (Terraform, Pulumi w trybie deklaratywnym), mechanizm sam decyduje „JAK”.
- Imperatywny: opisujesz sekwencję kroków („JAK”) – np. Ansible (playbook), klasyczne skrypty bash.
- Hybrydowy: mieszanka – np. Terraform + provisionery / zewnętrzne skrypty, Pulumi (kod ogólnego przeznaczenia steruje deklaratywnymi API).

### Terraform a inne narzędzia
| Cecha | Terraform | Ansible | ARM/Bicep | Pulumi |
|-------|-----------|---------|-----------|--------|
| Model | Deklaratywny graf | Imperatywno-deklaratywny | Deklaratywny | Deklaratywno-programistyczny |
| Wielu dostawców | Tak (provider plugins) | Ograniczone (gł. konfiguracja) | Tylko Azure | Tak |
| Stan | Plik state | Brak globalnego stanu zasobów | Brak (Azure API) | Wewnętrzny stan | 
| Ekosystem modułów | Bardzo duży (Registry + AVM) | Role Galaxy | Szablony/Moduły | Biblioteki w językach |

### Kluczowe korzyści biznesowe
1. Redukcja ryzyka – mniej „nieudokumentowanych” zmian.
2. Szybszy time-to-market – nowe środowisko w minutach zamiast dni.
3. Lepsze zarządzanie kosztami – parametryzacja SKU i rozmiarów pozwala szybko wprowadzić optymalizacje.
4. Spójne zabezpieczenia – wzorce bezpieczeństwa (NSG, Key Vault, Monitoring) ujęte jako moduły.

### Maturity Model (5 poziomów)
1. Ad-hoc Scripts – pojedyncze skrypty bez standaryzacji.
2. Structured IaC – użycie Terraform/ARM, podstawowe moduły.
3. Reusable Modules – modułowa architektura, wersjonowanie semver.
4. Policy & Compliance as Code – Sentinel / OPA / Azure Policy, enforce tagów i regionów.
5. Self-Service Platform – katalog gotowych blueprintów + automatyczne guardrails.

### Dobre praktyki techniczne
- Małe, czytelne moduły; zasada „single responsibility”.
- Jawne wersjonowanie providerów i modułów (`~>` lub exact pin dla krytycznych części).
- Separacja środowisk poprzez pliki `*.tfvars` + różne klucze backendu, NIE przez forki repo.
- Tagowanie zasobów (Owner, Environment, CostCenter, Compliance) – standaryzacja wymuszana politykami.
- Użycie Azure Verified Modules (AVM) gdzie dostępne – przyspiesza i zmniejsza ryzyko.

### Anti-patterny (co unikać)
- Ręczna edycja zasobów w portalu po wdrożeniu (powoduje DRIFT stanu).
- Ogromny „monorepo” moduł robiący wszystko – utrudnia refaktoring.
- Hardcodowane wartości (region, nazwy RG) zamiast zmiennych/locals.
- Sekrety w plikach `.tf` lub w niezaszyfrowanych outputach.
- Nadmiar `depends_on` – spowalnia plan i komplikuje graf.

### Wykrywanie i zarządzanie DRIFT
- `terraform plan` w pipeline cyklicznie (np. raz dziennie) – różnice oznaczają dryft.
- `terraform apply -refresh-only` aby zaktualizować stan po wyjątkowych ręcznych zmianach (lepiej ich nie robić).
- Integracja z Azure Activity Logs + alert jeśli zasób krytyczny zmieniony poza pipeline.

### Testowanie IaC
1. Static Analysis – tflint, checkov, terraform validate, tfsec (security scanning).
2. Unit-like – testy modułów (Terratest / Kitchen Terraform) – czy tworzy właściwe zasoby i atrybuty.
3. Policy Testing – Sentinel / OPA testy polityk.
4. Smoke/Integration – wdrożenie w ephemeral środowisku + podstawowe testy dostępności (np. HTTP 200).

### Metryki (pomiar dojrzałości)
- Deployment Frequency (ile razy dziennie/tyg. można zreplikować środowisko).
- Lead Time for Change (czas od pull request do wdrożenia produkcyjnego).
- Change Failure Rate (odsetek nieudanych apply vs. wszystkich).
- Mean Time to Recovery (czas od awarii do odtworzenia środowiska z kodu).

### Integracja w Azure
- Backend: Storage Account z włączonym soft delete + immutability opcjonalnie.
- Autoryzacja: Managed Identity + role (np. `Contributor` / granularne RBAC zamiast service principal z tajnym hasłem).
- Sekrety: przechowywane w Key Vault – terraform odczytuje referencje, nie wartości (gdy to możliwe).
- Monitorowanie: deployment zapisuje standardowe tagi + włącza Diagnostic Settings (Log Analytics).

### Compliance & Governance
- Tag enforcement przez Azure Policy + walidacja w planie (policy as code – Sentinel / OPA).
- Lista dozwolonych regionów – walidacja zmiennej `location` + polityka.
- Wymuszenie szyfrowania i braku public access dla Storage przez polityki + testy tflint.

### Migracja do IaC – kroki
1. Inwentaryzacja zasobów (Azure Resource Graph).
2. Decyzja: import czy rekreacja (dla zasobów stanowych np. baza – import).
3. Stopniowe „modelowanie” – każdy rodzaj zasobu to osobny moduł.
4. Walidacja w staging.
5. Przeniesienie stanu do zdalnego backendu.

### Rola locals i modułów
- `locals` zmniejszają powtórzenia (prefiksy nazw, wspólne tagi, mapy SKU).
- Moduły budują bibliotekę wzorców (networking, security baseline, logging). Ułatwia standaryzację.

### Security-by-Design w IaC
- Zero Trust: restrykcyjne NSG + private endpoints dla PaaS.
- Brak haseł statycznych – zamiast tego Managed Identity.
- Rozdział ról – oddzielne SP / MI dla provisioning vs. runtime.

### Checklist wdrożenia (przykład skrócony)
1. Czy plik lock jest skomitowany?
2. Czy wszystkie zmienne mają typ + opis?
3. Czy brak sekretów w outputach?
4. Czy plan został zrecenzowany (PR + komentarze)?
5. Czy polityki przeszły pozytywnie (Sentinel/OPA)?
6. Czy test ephemeral przeszedł smoke test?

### Najczęstsze problemy i jak je adresować
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| Dryft | Ręczne zmiany w portalu | Cykliczny plan + polityka zakazu manualnych zmian |
| Niespójne nazwy | Brak wzorca naming | `locals` + moduł naming + walidacja regex |
| Sekrety w stanie | Wykorzystanie plaintext values | Key Vault, ephemeral secrets (Terraform >=1.11) |
| Długi czas planu | Nadmiar providerów / modułów | Refaktoryzacja modułów + caching providera |
| Konflikty zespołu | Równoległe apply | Zdalny backend z locking (Blob lease) |

### Podsumowanie
IaC to fundament nowoczesnej chmury: powtarzalność, bezpieczeństwo, audytowalność i szybkość. Wdrożenie dojrzałe obejmuje: moduły, polityki, testy, CI/CD, monitoring dryftu i governance. Kolejny krok: narzędzia wspierające (instalacja, wersjonowanie) – temat 02.


## 02. Install Tools on macOS, Linux and Windows
Instalacja Terraform i narzędzi wspierających zależy od systemu operacyjnego, wymaga dbałości o wersjonowanie oraz integrację z pipeline CI/CD. Poniżej szczegółowe instrukcje i dobre praktyki dla każdego środowiska.

### 2.1. Instalacja Terraform

#### macOS
- Najprościej przez Homebrew:
  ```sh
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  ```
- Alternatywnie: pobierz binarkę z https://releases.hashicorp.com/terraform/ i rozpakuj do `/usr/local/bin`.

#### Linux
- Menedżer pakietów (np. Ubuntu):
  ```sh
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install terraform
  ```
- Ręcznie: pobierz ZIP, rozpakuj, wrzuć do `/usr/local/bin`.

#### Windows
- Chocolatey:
  ```powershell
  choco install terraform
  ```
- Winget:
  ```powershell
  winget install HashiCorp.Terraform
  ```
- Ręcznie: pobierz ZIP, rozpakuj, dodaj do PATH.

#### Wersjonowanie (tfenv)
- tfenv (https://github.com/tfutils/tfenv) pozwala łatwo przełączać wersje:
  ```sh
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv
  echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
  tfenv install 1.6.6
  tfenv use 1.6.6
  ```
- Dobre praktyki: zawsze pinuj wersję w pliku `.terraform.lock.hcl` i/lub w pipeline CI.

### 2.2. Dodatkowe narzędzia
- **tflint** – linting kodu HCL, wykrywanie błędów i antywzorców.
- **terraform-docs** – automatyczne generowanie dokumentacji z plików `variables.tf` i `outputs.tf`.
- **pre-commit** – automatyzacja formatowania, lintowania i testów przed commitem.
- **Azure CLI** – wymagany do autoryzacji i zarządzania zasobami Azure.
- **checkov, tfsec** – skanery bezpieczeństwa IaC.

#### Instalacja tflint
- macOS/Linux:
  ```sh
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  ```
- Windows: pobierz ZIP z GitHub Releases.

#### Instalacja terraform-docs
- macOS:
  ```sh
  brew install terraform-docs
  ```
- Linux:
  ```sh
  wget https://github.com/terraform-docs/terraform-docs/releases/download/v0.17.0/terraform-docs-v0.17.0-linux-amd64.tar.gz
  tar -xzf terraform-docs-*.tar.gz
  sudo mv terraform-docs /usr/local/bin/
  ```

#### Instalacja pre-commit
- Python pip:
  ```sh
  pip install pre-commit
  pre-commit install
  ```

### 2.3. Integracja z CI/CD
- W pipeline (GitHub Actions, Azure DevOps) używaj oficjalnych akcji lub tasków:
  - GitHub: `hashicorp/setup-terraform@v3`
  - Azure DevOps: `TerraformInstaller@1`
- Pinuj wersje narzędzi w pipeline, nie polegaj na „latest”.
- Przykład YAML (GitHub Actions):
  ```yaml
  jobs:
    terraform:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: hashicorp/setup-terraform@v3
          with:
            terraform_version: 1.6.6
        - run: terraform init
        - run: terraform validate
  ```

### 2.4. Dobre praktyki
- Zawsze sprawdzaj sumy SHA256 pobieranych binarek.
- Nie instaluj narzędzi globalnie na serwerach produkcyjnych – używaj kontenerów lub dedykowanych runnerów.
- Utrzymuj spójność wersji między lokalnym środowiskiem a CI/CD.
- Przechowuj plik `.terraform.lock.hcl` w repozytorium.
- Regularnie aktualizuj narzędzia pomocnicze (tflint, tfsec, terraform-docs).

### 2.5. Typowe błędy i pułapki
- Instalacja różnych wersji Terraform na tym samym PATH – prowadzi do nieprzewidywalnych efektów.
- Brak lock file – niekontrolowane aktualizacje providerów.
- Używanie „latest” w pipeline – ryzyko breaking changes.
- Brak narzędzi lintujących – trudniej wykryć błędy przed apply.
- Brak Azure CLI lub złe uprawnienia – błędy autoryzacji przy providerze azurerm.

### 2.6. Podsumowanie
Poprawna instalacja i wersjonowanie narzędzi to fundament stabilnych wdrożeń IaC. Automatyzuj instalację, pinuj wersje, integruj z pipeline, a unikniesz większości problemów na etapie wdrożenia i utrzymania.

## 03. Command Basics
Komendy Terraform tworzą spójny cykl życia pracy z infrastrukturą: przygotowanie środowiska, walidacja, planowanie, wykonanie, inspekcja i porządkowanie. Zrozumienie ich flag, typowych błędów i wzorców automatyzacji jest kluczowe dla stabilnych wdrożeń.

### 3.1. Przegląd głównych komend
| Faza | Komenda | Cel | Najważniejsze flagi |
|------|---------|-----|---------------------|
| Inicjalizacja | `terraform init` | Pobiera providerów, inicjalizuje backend, moduły | `-backend-config=`, `-upgrade`, `-reconfigure` |
| Walidacja | `terraform validate` | Sprawdza poprawność syntaktyczną i podstawową semantykę | (brak częstych flag) |
| Planowanie | `terraform plan` | Oblicza różnice między stanem a konfiguracją | `-var/-var-file`, `-out`, `-input=false`, `-refresh=false`, `-target` (ostrożnie) |
| Wykonanie | `terraform apply` | Wprowadza zmiany opisane w planie | `-auto-approve`, `-input=false`, użycie pliku planu |
| Usuwanie | `terraform destroy` | Usuwa zasoby zarządzane | `-auto-approve`, `-target` |
| Inspekcja stanu | `terraform show`, `terraform state *` | Wyświetla plan/stanu, manipulacja | `-json` |
| Deploy bez zmian zasobów | `terraform apply -refresh-only` | Aktualizacja stanu z realnej infrastruktury | `-refresh-only` |

### 3.2. `terraform init`
Cel: przygotowanie katalogu roboczego. Wykrywa konfigurację backendu i providerów, tworzy/lokuje plik lock, pobiera moduły.
- Używaj `-upgrade` aby zaktualizować provider do najnowszej wersji zgodnej z constraintem.
- `-reconfigure` gdy zmienisz backend i chcesz wymusić ponowną konfigurację bez migracji.
- Typowy błąd: zmiana konfiguracji backendu bez `-migrate-state` – może skutkować utworzeniem pustego stanu.
Przykład (Azure backend, parametry z pliku):
```sh
terraform init -backend-config=backend.hcl
```
Plik `backend.hcl` może zawierać np. `resource_group_name`, `storage_account_name` itd. – nie commituj sekretów.

### 3.3. `terraform validate`
Sprawdza syntaksę i podstawową spójność (czy referencje istnieją). Nie wykonuje grafu dostawcy ani zapytań do API. Używaj w pre-commit oraz jako pierwszy krok w pipeline.
- Nie wykrywa błędów runtime (np. brak uprawnień w Azure) – to wyjdzie w plan/apply.

### 3.4. `terraform plan`
Najważniejsza komenda analityczna. Tworzy potencjalny graf operacji (Create/Update/Delete/Replace).
- `-out=plan.bin` – zapis planu do pliku (nie tekstowy). Używaj w CI aby zagwarantować, że apply wykona dokładnie obejrzany plan.
- `-input=false` – wyłącza interaktywne pytania (w CI konieczne).
- `-var-file=dev.tfvars` – parametry środowiska.
- `-refresh=false` – przyspiesza plan jeśli wiesz, że stan jest świeży (ostrożnie – ryzyko dryftu niewidocznego w planie).
- `-target=resource.address` – częściowy plan; stosować bardzo oszczędnie (może zniekształcić zależności).
- Wyjście kolorowe vs. `-no-color` dla logów CI.
Typowe ostrzeżenia: „value for undeclared variable” – plik `tfvars` zawiera wpis bez definicji zmiennej.

### 3.5. `terraform apply`
Realizuje zaplanowane zmiany. Dwa tryby:
1. Z planem wprost: `terraform apply -auto-approve` (oblicza plan wewnątrz i wykonuje – mniej kontrolowane).
2. Z przygotowanego pliku: `terraform apply plan.bin` (zalecane w CI – hermetyzuje krok zatwierdzenia).
Flagi:
- `-auto-approve` – bez interaktywnego zatwierdzenia (tylko w automatyzacji po review).
- `-input=false` – konsystencja z pipeline non-interactive.
Wzorce bezpieczeństwa: w prod brak `-auto-approve` + manualny gate (PR + approval).

### 3.6. `terraform destroy`
Usuwa wszystkie zasoby zarządzane przez stan. Używaj z rozwagą w środowiskach współdzielonych.
- Preferuj etapowe wygaszanie (np. `-target` dla testowych zasobów), ale unikaj nadużycia target.
- Wkład w koszty: oczyszcza zasoby pozostawione po testach ephemeral.

### 3.7. Inspekcja i manipulacja stanu
- `terraform show` – pokazuje szczegóły planu lub stanu; z `-json` do analizy maszynowej.
- `terraform state list` / `show` / `mv` / `rm` – narzędzia korekcyjne; stosuj jako ostatnią deskę ratunku (lepiej poprawić kod i zre-aplikować).
- `terraform providers` – lista providerów użytych w konfiguracji + wersje.

### 3.8. Specjalne tryby
- `apply -refresh-only` – synchronizacja stanu bez zmiany zasobów (detekcja ręcznych modyfikacji).
- `plan -destroy` – plan w kontekście destrukcji (przed pełnym `destroy`).
- `plan -generate-config-out=...` (eksperymentalne w narzędziach) – generowanie bloków z istniejącego stanu (alternatywy w zewnętrznych toolach).

### 3.9. Typowe błędy i ich diagnoza
| Objaw | Przyczyna | Rozwiązanie |
|-------|-----------|-------------|
| `Backend initialization required` | Zmiana backendu bez `-reconfigure` | `terraform init -reconfigure` |
| Provider version conflict | Constraint niezgodny z lock file | Usuń lock lub zmień constraint, potem `init -upgrade` |
| Brak uprawnień do subskrypcji Azure | Zły token / brak roli | Odśwież login (Azure CLI), sprawdź RBAC |
| Plan bardzo wolny | Za dużo data sources / remote calls | Ogranicz data sources, cache parametry wejściowe |
| Dryft niewidoczny | Użyto `-refresh=false` przy plan | Wykonaj plan bez tej flagi cyklicznie |

### 3.10. Automatyzacja w CI/CD (przykładowy pipeline logiczny)
1. Checkout kodu
2. `terraform fmt -check` + lint (tflint, tfsec)
3. `terraform init`
4. `terraform validate`
5. `terraform plan -out=plan.bin -input=false -var-file=env.tfvars`
6. Publikacja planu jako artefakt + komentarz w PR (maskowanie sekretów)
7. Approval manualny
8. `terraform apply plan.bin`
9. Testy post-deployment (np. HTTP, porty, tagi, NSG)
10. Monitoring i cost checks (opcjonalnie)

### 3.11. Dobre praktyki
- Nigdy nie stosuj `apply` bez wcześniejszego obejrzenia planu (ręcznie albo artefakt w PR).
- Używaj pliku planu w produkcji (`-out` + apply plan.bin) – gwarancja spójności.
- Minimalizuj użycie `-target` – zaburza graf zależności.
- Wymuszaj `-input=false` w automatyzacji – unikniesz wiszących jobów.
- Zbieraj metryki: czas trwania planu, liczba zmian, liczba odrzuconych planów.
- Audytuj częstotliwość destroy – nadmierne kasowanie może oznaczać brak stabilności procesu.

### 3.12. Kontekst Azure (specyfika)
- Przy inicjalizacji backendu pamiętaj o roli dostępu do Storage (Blob Data Contributor lub wyższa + Resource Group poziom).
- Przy wielu subskrypcjach – aliasy providerów + separacja authentication (Managed Identity / Service Principal).
- Zasoby typu NSG / Route Table często pojawiają się w planie jako „replace” gdy zmienia się zestaw reguł – redukuj fluktuacje stabilnym sortowaniem i stałymi nazwami.

### 3.13. Checklist przed `apply`
1. Czy plan nie zawiera nieoczekiwanych destrukcji? (szukaj `-/+` lub `- destroy`)
2. Czy wersja Terraform zgodna z polityką organizacji?
3. Czy lint i security scan są zielone?
4. Czy tagi obowiązkowe są obecne w planie (np. cost center)?
5. Czy brak sekretów w diff (np. wartości Key Vault)?
6. Czy polityki (Sentinel/OPA) przeszły bez blokad?

### 3.14. Podsumowanie
Komendy bazowe Terraform tworzą deterministyczny cykl pracy. Świadome użycie flag (zwłaszcza `-out`, `-input=false`, `-var-file`, `-refresh=false`) oraz rygor obejrzenia planu przed apply minimalizują ryzyko. Kolejny krok: głębsza składnia języka – temat 04.

## 04. Language Syntax
Język HCL (HashiCorp Configuration Language) łączy deklaratywną składnię z ekspresyjnymi wyrażeniami. Pozwala opisać docelowy stan infrastruktury, a Terraform buduje graf zależności i wyznacza operacje. Zrozumienie typów, wyrażeń i reguł interpolacji jest kluczowe dla utrzymania czytelności i minimalizacji błędów.

### 4.1. Struktura pliku
- Bloki: `terraform`, `provider`, `resource`, `data`, `variable`, `locals`, `output`, `module`.
- Argumenty: pary `klucz = wartość` wewnątrz bloków.
- Zagnieżdżone bloki podrzędne (np. `os_disk {}`, `source_image_reference {}` w VM).

### 4.2. Typy danych
| Typ | Opis | Przykład |
|-----|------|----------|
| string | Tekst | `"westus"` |
| number | Liczby całkowite/zmiennoprzecinkowe | `42`, `3.14` |
| bool | Logiczny | `true` |
| list(T) | Uporządkowana kolekcja | `["a", "b"]` |
| map(T) | Klucz->wartość | `{ env = "dev" }` |
| set(T) | Unikalne wartości (kolejność nieistotna) | `toset(["dev","prod"])` |
| object({...}) | Struktura nazwanych pól | `object({name=string, size=string})` |
| tuple([...]) | Pozycje określonych typów | `tuple([string, number])` |

### 4.3. Interpolacja
Wyrażenia w `${}` były wymagane w starszych wersjach; obecnie większość wartości może być wyrażeniem bez `${}` (np. `name = var.name`). Interpolację stosuj tylko w złożonych łańcuchach: `"${var.prefix}-sa-${random_string.suffix.result}"`.

### 4.4. Operatory i wyrażenia
- Logiczne: `&&`, `||`.
- Porównania: `==`, `!=`, `>`, `<`, `>=`, `<=`.
- Ternary: `condition ? value_if_true : value_if_false`.
- Konkatenacja list: `["a"] + ["b"]`.
- Konkatenacja map: `merge(map1, map2)`.

### 4.5. Pętle i transformacje
- `for` expression (list): `[for r in var.regions: lower(r)]`.
- Filtrowanie: `[for r in var.regions: r if r != "eastus"]`.
- Tworzenie map: `{for k,v in var.instances: k => v.size}`.

### 4.6. Funkcje vs. locals
Gdy wyrażenie staje się nieczytelne, przenieś je do `locals`:
```hcl
locals {
  naming_prefix = lower(join("-", [var.project, var.environment]))
}
resource "azurerm_resource_group" "rg" {
  name     = "${local.naming_prefix}-rg"
  location = var.location
}
```

### 4.7. Walidacja i typowanie
Deklaruj typy w zmiennych – szybciej wykrywasz błędy niż podczas planu.
```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
  }
}
```

### 4.8. Komentarze i styl
- Używaj `#` lub `//` dla krótkich komentarzy; `/* */` dla blokowych.
- Unikaj komentarzy mówiących „co kod robi” – zamiast tego tłumacz „dlaczego”.
- Formatowanie: zawsze `terraform fmt` (zautomatyzowane w pre-commit).

### 4.9. Najczęstsze błędy składni
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| `Invalid function argument` | Zły typ w funkcji | Dodaj konwersję (`tostring()`, `tonumber()`) |
| `Invalid index` | Indeks poza zakresem listy | Użyj `length(list)` w warunku |
| `Unsupported attribute` | Odwołanie do atrybutu który nie istnieje | Sprawdź dokumentację providera |
| `Duplicate key` | Ten sam klucz w mapie | Użyj `merge()` z unikaniem kolizji |

### 4.10. Dobre praktyki
- Nazwy bloków logicznych: krótkie, semantyczne (`rg`, `vnet`, `nsg`).
- Używaj locals do wzorców nazewniczych; unikaj powtórzeń łańcuchów.
- Wrażliwe wartości NIE powinny być budowane z części w locals, jeśli każdy element jest secret – trzymaj secret jako całość.
- Waliduj regiony, SKU, długości nazw (Azure ma limity).

### 4.11. Podsumowanie
HCL jest prosty, ale ekspresyjny: im bardziej strukturujesz kod (typy, locals, pętle), tym mniej błędów i powtórzeń. Kolejny krok: blok ustawień Terraform – temat 05.

## 05. Settings Block
Blok `terraform {}` kontroluje wersjonowanie, backend oraz wymagane provider’y. To centralne miejsce polityk technicznych projektu.

### 5.1. Składniki
- `required_version` – ogranicza wersję binarki Terraform (zapobiega niespodziankom przy aktualizacji).
- `required_providers` – definicje źródła (namespace), wersjonowanie semver.
- `backend` – konfiguracja przechowywania stanu (Azure Storage, Terraform Cloud, S3 itd.).
- Eksperymentalne cechy (rzadko używane w stabilnych środowiskach).

### 5.2. Przykład
```hcl
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstateprod"
    container_name       = "tfstate"
    key                  = "prod.tfstate"
  }
}
```

### 5.3. Dobre praktyki
- Nie hardcoduj wartości subskrypcji / identyfikatorów – pobieraj przez zmienne środowiskowe (`ARM_SUBSCRIPTION_ID`).
- Pinuj wersje dostawców (`~>` lub exact) – minimalizujesz ryzyko breaking changes.
- Plik lock commituj do repo.
- Backend parametry (np. nazwy Storage) trzymaj w zewnętrznym pliku `backend.hcl` – łatwiejsza rotacja.

### 5.4. Typowe błędy
| Błąd | Przyczyna | Rozwiązanie |
|------|-----------|-------------|
| `Incompatible provider version` | Nowa wersja poza constraintem | Zaktualizuj constraint lub lock file |
| `Backend initialization required` | Zmiana backendu | `terraform init -reconfigure` |
| Brak autoryzacji do konta Storage | Uprawnienia RBAC | Dodaj rolę `Storage Blob Data Contributor` |

### 5.5. Podsumowanie
Settings Block wyznacza ramy techniczne projektu – stabilność i przewidywalność zaczyna się tutaj.

## 06. Providers Block
Provider to wtyczka mówiąca Terraform jak komunikować się z danym API. Kontroluje autoryzację, funkcje dodatkowe i specyficzne zachowania.

### 6.1. Przykład bazowy (Azure)
```hcl
provider "azurerm" {
  features {}
}
```

### 6.2. Aliasowanie
Stosowane przy multi-region / multi-subscription:
```hcl
provider "azurerm" {
  features {}
  alias           = "we"
  subscription_id = var.sub_we
}
provider "azurerm" {
  features {}
  alias           = "ne"
  subscription_id = var.sub_ne
}
```
Użycie w zasobie: `provider = azurerm.we`.

### 6.3. Dobre praktyki
- Minimalne `features {}` – nie dodawaj pustych sekcji które nic nie wnoszą.
- Unikaj mieszania wielu providerów do jednej odpowiedzialności (np. storage w random + azurerm).
- Dokumentuj aliasy – w README sekcja „Multi-region mapping”.

### 6.4. Typowe błędy
| Problem | Przyczyna | Fix |
|---------|-----------|-----|
| `multiple provider configurations` nieużywane | Alias zdefiniowany ale brak przypisania w zasobach | Usuń alias lub użyj go |
| Brak autoryzacji | Niepoprawny token / brak roli | Odśwież login / przypisz RBAC |
| Nieprzewidywalne zmiany wersji | Brak pinowania | Dodaj wersję w Settings Block |

### 6.5. Podsumowanie
Providers są mostem do chmury – przejrzysta konfiguracja i pinowanie wersji zapewniają powtarzalność.

## 07. Multiple Providers usage
W wielu projektach potrzebujesz więcej niż jednego providera: Azure + Random + TLS + External. Możesz też mieć wiele konfiguracji tego samego typu (aliasy).

### 7.1. Przykład
```hcl
provider "azurerm" {
  features {}
  alias = "we"
}
provider "azurerm" {
  features {}
  alias = "ne"
}
```

### 7.2. Kiedy stosować
- Multi-region replikacja (np. VNet w West i North Europe).
- Rozdział subskrypcji (network vs. aplikacje).
- Migracje – stary i nowy tenant jednocześnie.

### 7.3. Dobre praktyki
- Konsystentne nazwy aliasów (`we`, `ne`, `prod`, `dr`).
- Wydziel zmienne dla identyfikatorów subskrypcji – nie zapisuj ich w kodzie.
- Unikaj logiki warunkowej wybierającej providera – lepiej jawnie przypisać w zasobach.

### 7.4. Typowe błędy
| Błąd | Opis | Rozwiązanie |
|------|------|-------------|
| Adresowanie niewłaściwego providera | Brak `provider =` przy zasobie | Dodaj `provider = azurerm.alias` |
| Chaos aliasów | Niespójne nazwy | Ustal konwencję w README |

### 7.5. Podsumowanie
Wielu providerów rozszerza możliwości – trzymaj aliasy czytelne i kontroluj wersje.

## 08. Dependency Lock File Importance
Plik `.terraform.lock.hcl` gwarantuje identyczne wersje providerów (i sumy SHA256) w każdym środowisku.

### 8.1. Rola
- Stabilność wersji.
- Ochrona przed wrogą podmianą binarki (weryfikacja checksum).
- Reprodukowalność CI/CD.

### 8.2. Dobre praktyki
- Commituj plik – to nie jest artefakt tymczasowy.
- Aktualizuj świadomie: `terraform init -upgrade` po zmianie constraintów.
- Przeglądaj diff w PR – jeśli zmieniły się wersje, oceń wpływ (release notes).

### 8.3. Typowe błędy
| Błąd | Skutek | Fix |
|------|--------|-----|
| Usunięcie pliku | Nagłe aktualizacje providerów | Przywróć z historii Git |
| Ręczna edycja | Niespójne checksum | Wygeneruj ponownie przez `init` |

### 8.4. Podsumowanie
Lock file to fundament kontroli zależności – traktuj go jak część kodu.

## 09. Resources Syntax and Behavior
Zasób (`resource`) opisuje pojedynczy element infrastruktury. Terraform buduje graf zależności i określa operacje CRUD.

### 9.1. Składnia
```hcl
resource "typ" "nazwa" {
  argument = wartosc
}
```

### 9.2. Idempotencja
Powtórne `apply` bez zmian → brak operacji. Jeśli zmienisz atrybut – Terraform wybiera update / replace (jeśli zasób tego wymaga).

### 9.3. Zależności
- Implicit: referencje (`resource_group_name = azurerm_resource_group.rg.name`).
- Explicit: `depends_on` – używać tylko gdy brak odniesienia a zależność istnieje (np. moduł vs. zasób).

### 9.4. Cykle i błędy grafu
Jeżeli dwa zasoby odwołują się wzajemnie do swoich atrybutów powstanie cykl (Terraform zgłosi błąd). Rozwiąż poprzez rozdzielenie lub użycie data source (ostrożnie).

### 9.5. Dobre praktyki
- Nazwy logiczne zasobów w kodzie krótkie; „prawdziwe” nazwy budowane z prefixów.
- Unikaj powielania tagów – użyj locals.
- Grupuj pokrewne zasoby w dedykowanych plikach (np. `networking.tf`).

### 9.6. Typowe problemy
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| Replace zasobu (destroy/create) | Zmiana atrybutu immutable | Zaplanuj okno serwisowe lub użyj innego SKU |
| Brak referencji a mimo to kolejność błędna | Użyto data source zamiast zależności | Dodaj explicit `depends_on` |
| Chaotyczne nazwy | Brak konwencji | Wdroż naming module |

### 9.7. Podsumowanie
Zrozumienie zachowań zasobów (update vs. replace) minimalizuje niespodziewane przerwy w usługach.

## 10. Resources Meta-Argument - depends_on
`depends_on` dodaje jawne krawędzie w grafie zależności.

### 10.1. Przykład
```hcl
module "network" {
  source = "./modules/network"
}
resource "azurerm_private_endpoint" "pe" {
  name                = "pe-db"
  # ...
  depends_on = [module.network] # brak bezpośrednich referencji do zasobów wewnątrz modułu
}
```

### 10.2. Dobre zastosowania
- Zależność od modułu (gdy brak ekspozycji atrybutu).
- Kolejność przy zasobach dostawcy o niejawnych constraintach (rzadkie przypadki).

### 10.3. Antywzorce
- Dodawanie `depends_on` gdy już referencja istnieje.
- Łączenie wielu modułów w pojedynczej liście bez potrzeby.

### 10.4. Podsumowanie
Stosuj oszczędnie – nadmiar spowalnia plan i utrudnia refaktoryzację.

## 11. Resources Meta-Argument - count
`count` – najprostszy sposób na wielokrotne tworzenie zasobu lub warunkowe całkowite wyłączenie (`count = 0`).

### 11.1. Przykład 0/1
```hcl
resource "azurerm_public_ip" "pip" {
  count = var.enable_public_ip ? 1 : 0
  # ...
}
```
Odwołanie: `azurerm_public_ip.pip[0].ip_address` (tylko gdy count=1).

### 11.2. Lista elementów
```hcl
variable "subnets" { type = list(string) }
resource "azurerm_subnet" "subnet" {
  count                = length(var.subnets)
  name                 = var.subnets[count.index]
  virtual_network_name = azurerm_virtual_network.vnet.name
  # ...
}
```

### 11.3. Wady
- Zmiana kolejności listy powoduje potencjalne destructions / recreations.
- Wstawienie elementu w środek przesuwa indeksy.

### 11.4. Kiedy używać
- Małe listy bez zmian kolejności.
- Warunkowa obecność pojedynczego zasobu.

### 11.5. Antywzorce
- Stosowanie dla kolekcji, które ewoluują (lepiej `for_each`).

### 11.6. Podsumowanie
`count` jest prosty, ale kruche adresowanie – preferuj `for_each` dla stabilności.

## 12. Resources Meta-Argument - for_each
`for_each` zapewnia stabilne adresy zasobów bazujące na kluczach mapy lub wartościach setu.

### 12.1. Przykład (mapa obiektów)
```hcl
variable "vms" {
  type = map(object({ size=string, enable_backup=bool }))
}
resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = var.vms
  name                = each.key
  size                = each.value.size
  # ...
}
```
Odwołanie: `azurerm_linux_virtual_machine.vm["app01"].id` stabilne nawet przy dodaniu nowych kluczy.

### 12.2. Zalety
- Stabilność adresów.
- Łatwe filtrowanie przez locals (tworzenie mapy pośredniej).

### 12.3. Wady
- Klucz zmieniony → destroy + create.
- Nie nadaje się gdy potrzebujesz kolejności (użyj listy + count jeśli ma znaczenie order).

### 12.4. Dobre praktyki
- Ustal konwencję kluczy (bez spacji, małe litery, `[-a-z0-9]`).
- Filtrowanie przez locals: `local.enabled_vms = {for k,v in var.vms: k => v if v.enable_backup}`.

### 12.5. Podsumowanie
Preferowany mechanizm dla kolekcji nazwanych – minimalizuje przypadkowe rekreacje.

## 13. Resources Meta-Argument - for_each Maps
Mapy są najczęstszym źródłem dla `for_each`.
Gdy używasz mapy:
```hcl
for_each = var.serwery
name     = each.key
size     = each.value.size
```
### 13.1. Korzyści
- Odczyt po nazwie (semantyczne).
- Możliwość przechowywania wielu parametrów (obiekt jako wartość).

### 13.2. Przykład zaawansowany
```hcl
variable "rules" {
  type = map(object({ port=number, priority=number }))
}
resource "azurerm_network_security_rule" "rule" {
  for_each                    = var.rules
  name                        = each.key
  destination_port_range      = each.value.port
  priority                    = each.value.priority
  # ...
}
```

### 13.3. Podsumowanie
Mapy zapewniają przejrzystość adresowania i łatwość refaktoryzacji.

## 14. Resources Meta-Argument - for_each ToSet
`toset(list)` konwertuje listę na set (wymagane unikalne wartości). Kluczem staje się sama wartość.

### 14.1. Przykład
```hcl
variable "regions" { type = list(string) }
resource "azurerm_resource_group" "rg" {
  for_each = toset(var.regions)
  name     = "rg-${each.key}"
  location = each.key
}
```

### 14.2. Zalety
- Szybka deklaracja bez mapy.
- Proste gdy każdy element identycznie traktowany.

### 14.3. Wady
- Trudno rozszerzyć o dodatkowe parametry – wtedy lepiej mapa.

### 14.4. Podsumowanie
Dobry wybór dla jednolitych, unikalnych wartości bez dodatkowych metadanych.

## 15. Resources Meta-Argument - for_each Chaining
Chaining = tworzenie przetworzonych kolekcji pośrednich przed użyciem w `for_each`.
Możesz budować kolekcje pośrednie w lokalnych:
```hcl
locals {
  final = {for k,v in var.items: k => v if v.enabled}
}
resource "x" "y" { for_each = local.final }
```
### 15.1. Zastosowania
- Filtrowanie elementów na podstawie warunków.
- Mapowanie struktur (np. dodanie domyślnych tagów).

### 15.2. Ryzyka
- Zmiana kluczy po transformacji → rekreacje.
- Składanie zbyt wielu warstw utrudnia debug.

### 15.3. Debug
Wyświetl lokalną wartość przez `terraform console` lub chwilowy output.

### 15.4. Podsumowanie
Potężne narzędzie do przygotowania danych – zachowaj umiar i przejrzystość.

## 16. Azure Linux Virtual Machine with Terraform
Tworzenie maszyny wymaga zasobów towarzyszących: RG, VNet, Subnet, NIC, opcjonalnie Public IP, NSG. Minimalny przykład:
Tworzenie maszyny:
```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "srv-app-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = var.admin_user
  network_interface_ids = [azurerm_network_interface.nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
```
### 16.1. Hardenowanie
- Użyj `admin_ssh_key` zamiast hasła.
- Dodaj `identity { type = "SystemAssigned" }` dla Managed Identity.
- Cloud-init dla pakietów i konfiguracji (zamiast provisionerów):
```hcl
custom_data = filebase64("scripts/cloud-init.yaml")
```

### 16.2. Monitoring
- Tagowanie standardowe.
- Włączenie boot diagnostics (Storage lub Managed).

### 16.3. Typowe błędy
| Błąd | Przyczyna | Rozwiązanie |
|------|-----------|-------------|
| `Password authentication failed` | Użyto hasła zamiast klucza, brak poprawnych uprawnień | Przejdź na SSH key |
| Rekreacja VM przy zmianie obrazu | `version = latest` zmienia się | Pinuj obraz lub automation do testów |

### 16.4. Podsumowanie
VM w Azure najlepiej zarządzać bez provisionerów – Cloud-init + Managed Identity upraszczają utrzymanie.

## 17. Resources Meta-Argument - lifecycle create_before_destroy
Chroni dostępność przy wymianie zasobów wymagających zastąpienia.
Zapewnia kolejność przy zamianie zasobów (np. wymiana public IP):
```hcl
lifecycle { create_before_destroy = true }
```
### 17.1. Zastosowania
- Public IP, NIC, Load Balancer konfiguracje.
- Certyfikaty rotowane (TLS provider).

### 17.2. Ryzyka
- Tymczasowy wzrost liczby zasobów (quota exhaustion).
- Potencjalne koszty (dodatkowy czas życia starego + nowego).

### 17.3. Podsumowanie
Stosuj selektywnie – tylko gdy konieczna ciągłość usług.

## 18. Resources Meta-Argument - lifecycle prevent_destroy
Blokuje operację `destroy` na zasobie.
Chroni przed przypadkowym usunięciem:
```hcl
lifecycle { prevent_destroy = true }
```
### 18.1. Zastosowania
- Bazy danych produkcyjne.
- Kluczowe Storage z danymi stanu.

### 18.2. Proces
- Wymagaj PR z usunięciem tego parametru + manualny approval.

### 18.3. Podsumowanie
Prosty, skuteczny guardrail – dokumentuj jego użycie.

## 19. Resources Meta-Argument - lifecycle ignore_changes
Pozwala pominąć wykrywanie zmian w wybranych polach.
Ignoruje wybrane pola zmieniane ręcznie:
```hcl
lifecycle { ignore_changes = [ tags ] }
```
### 19.1. Zastosowania
- Pola automatycznie nadpisywane przez systemy zewnętrzne (np. monitoring agent).

### 19.2. Ryzyka
- Ukryty dryft prowadzący do niespójności.
- Utrudnione bezpieczeństwo (np. tagi compliance modyfikowane poza kodem).

### 19.3. Alternatywy
- Ustandaryzuj źródło prawdy (Terraform lub system X, nie oba).

### 19.4. Podsumowanie
Stosuj tylko gdy istnieje akceptowany proces zewnętrzny aktualizacji pola.

## 20. Input Variables - Basics
Zmienne to interfejs wejściowy modułu/root konfiguracji. Zapewniają parametryzację bez modyfikacji kodu.
Zmienne definiowane blokiem:
```hcl
variable "location" { type = string default = "westeurope" }
```
### 20.1. Dobre praktyki
- Dodaj opis: `description = "Azure region for deployment"`.
- Używaj typów złożonych świadomie (object) gdy parametry są powiązane semantycznie.
- Unikaj pustych defaultów dla kolekcji – preferuj jawne przekazanie.

### 20.2. Typowe błędy
| Błąd | Skutek | Rozwiązanie |
|------|--------|-------------|
| Brak typu | Późne wykrycie błędu | Dodaj `type =` |
| Niepotrzebny default secretu | Secret w stanie | Usuń default, użyj Terraform Cloud var |

### 20.3. Podsumowanie
Czytelne, typowane zmienne zmniejszają liczbę błędnych planów.

## 21. Input Variables - Assign When Prompted
Tryb interaktywny (prompt) działa jeśli zmienna nie ma wartości z żadnego źródła. 

### 21.1. Zastosowanie
- Szybkie manualne testy lokalne.

### 21.2. Wady
- Blokuje CI/CD (job czeka na input).
- Ryzyko pomyłek (literówki) i brak audytu.

### 21.3. Podsumowanie
Do eksperymentów – w produkcyjnym procesie unikaj.

## 22. Input Variables - Override default with CLI var
Nadpisanie pojedynczej wartości przez `-var`.
`terraform plan -var "location=polandcentral"`

### 22.1. Zastosowania
- Jednorazowe sprawdzenie alternatywnego regionu.

### 22.2. Wady
- Przy większej liczbie wartości robi się nieczytelne.
- Ryzyko wycieku sekretu w historii shell (bash history).

### 22.3. Podsumowanie
Stosuj sporadycznie – preferuj `tfvars`.

## 23. Input Variables - Override with environment variables
Środowiskowe przypisanie przez prefiks `TF_VAR_`.
`export TF_VAR_location=westeurope`

### 23.1. Zastosowania
- Sekrety w CI (Terraform Cloud / GitHub Actions) – wartości nie pojawiają się w pliku.

### 23.2. Wady
- Trudniejsze śledzenie źródła wartości.
- Możliwość kolizji gdy wiele procesów ustawia różne TF_VAR.

### 23.3. Dobre praktyki
- Dokumentuj nazwy w README.
- W CI ustaw tylko w kroku plan/apply (krótki czas życia).

### 23.4. Podsumowanie
Dobre dla sekretów – dla jawnych parametrów lepiej plik `tfvars`.

## 24. Input Variables - Assign with terraform.tfvars
Domyślny plik ładowany bez dodatkowych flag.

### 24.1. Zastosowania
- Główne parametry dla środowiska (dev).

### 24.2. Dobre praktyki
- Nie umieszczaj sekretów – użyj Terraform Cloud vars.
- Dodaj komentarze (HCL) przy nietypowych wartościach.

### 24.3. Podsumowanie
Wygodny domyślny kontener parametrów.

## 25. Input Variables - Assign with tfvars var-file argument
Flaga `-var-file` pozwala wskazać alternatywny zestaw wartości.
`terraform plan -var-file=prod.tfvars`

### 25.1. Zastosowania
- Wielo-środowiskowe wdrożenia (dev/test/prod) bez duplikacji kodu.

### 25.2. Dobre praktyki
- Spójna lista różnic (region, SKU, scale) – nie zmieniaj fundamentów architektury.
- Nazewnictwo: `dev.tfvars`, `test.tfvars`, `prod.tfvars`.

### 25.3. Typowe błędy
| Błąd | Opis | Fix |
|------|------|-----|
| Zbędne wartości | Definicja nieużywanej zmiennej | Usuń lub dodaj zmienną w `variables.tf` |
| Duplikacja parametrów między plikami | Powielanie maintenance burden | Przenieś wspólne do domyślnego pliku, nadpisuj tylko różnice |

### 25.4. Podsumowanie
Najczystsza forma separacji parametrów środowiskowych.

## 26. Input Variables - Assign with auto tfvars
Każdy plik kończący się `.auto.tfvars` jest automatycznie ładowany w porządku alfabetycznym.

### 26.1. Zastosowania
- Rozdzielenie domen parametrów (np. `network.auto.tfvars`, `security.auto.tfvars`).

### 26.2. Dobre praktyki
- Zachowaj przewidywalność kolejności – unikaj nazw powodujących niechciane nadpisania.
- Dokumentuj w README kolejność.

### 26.3. Podsumowanie
Przydatne przy skalowaniu zespołów – wymaga dyscypliny nazewnictwa.

## 27. Input Variables - Lists
Listy zachowują kolejność.

### 27.1. Zastosowania
- Priorytety, sekwencje portów.
- Parametry gdzie kolejność wpływa na rezultat.

### 27.2. Wady
- Dodanie elementu w środku przy `count` destabilizuje adresy.

### 27.3. Podsumowanie
Używaj gdy order jest wymagany – w innych przypadkach preferuj mapy.

## 28. Input Variables - Maps
Mapy zapewniają adresowanie po nazwie.

### 28.1. Zastosowania
- Kolekcje zasobów (VM, NSG rules) z dodatkowymi polami.
- Konfiguracje per komponent.

### 28.2. Dobre praktyki
- Klucze zgodne z naming policy.
- Wartości jako obiekty dla grup parametrów.

### 28.3. Podsumowanie
Domyślny wybór dla większości kolekcji parametrów.

## 29. Input Variables - Validation Rules
Walidacje eliminują złe wartości przed planem.
Blok `validation { condition = ... error_message = ... }` pozwala walidować np. regiony.
```hcl
validation {
  condition     = contains(["westeurope","northeurope"], var.location)
  error_message = "Dozwolone tylko West/North Europe"
}
```
### 29.1. Dobre praktyki
- Waliduj listy regionów, SKU, zakresy długości stringów.
- Twórz wspólny lokal `allowed_regions` aby uniknąć duplikacji.

### 29.2. Podsumowanie
Walidacje redukują liczbę błędnych PR – inwestycja w jakość na wejściu.

## 30. Input Variables - Sensitive Input Variables
`sensitive = true` maskuje wartość w output planu i apply.

### 30.1. Dobre praktyki
- Nie dawaj defaultów dla secretów.
- Przechowuj w Terraform Cloud / Vault / Key Vault – a nie w repo.

### 30.2. Ograniczenia
- W stanie wartość nadal jest dostępna (chyba że provider używa ephemeral secrets >1.11).

### 30.3. Podsumowanie
Ochrona przed wyciekiem w logach – pełne bezpieczeństwo wymaga właściwego źródła sekretów.

## 31. Input Variables - Structural Type Object
Obiekty grupują parametry semantycznie powiązane – zmniejszają liczbę osobnych zmiennych.
Obiekty pozwalają grupować spójne parametry:
```hcl
variable "vm" {
  type = object({ size=string, enable_backup=bool })
}
```
### 31.1. Zalety
- Jedno miejsce walidacji typów.
- Mniejszy chaos w `variables.tf`.

### 31.2. Wady
- Zmiana struktury wymaga modyfikacji wszystkich wywołań modułu.

### 31.3. Podsumowanie
Stosuj dla spójnych grup parametrów (np. parametry VM, parametry NSG rule).

## 32. Input Variables - Structural Type tuple
Tuple definiuje pozycje i ich typy – bez nazw.

### 32.1. Zastosowania
- Gdy kolejność i typ są krytyczne, nazwy niepotrzebne.

### 32.2. Wady
- Mniej czytelne niż obiekt.
- Trudniejsze utrzymanie (indeks zamiast nazwy).

### 32.3. Podsumowanie
Rzadko stosuj – obiekt prawie zawsze lepszy.

## 33. Input Variables - Structural Type sets
`set(T)` zapewnia unikalność i brak gwarancji kolejności.

### 33.1. Zastosowania
- Zbiór unikalnych regionów.
- Lista tagów bez znaczenia kolejności.

### 33.2. Wady
- Nie zachowuje pierwotnej kolejności – nie używać gdy order ma znaczenie.

### 33.3. Podsumowanie
Idealne gdy chcesz tylko sprawdzić przynależność i unikalność.

## 34. Output Values - Basics
Outputy udostępniają informacje po `apply` oraz dla `terraform_remote_state`.

### 34.1. Dobre praktyki
- Dodaj `description`.
- Nie wypisuj sekretów – jeśli musisz, oznacz `sensitive = true`.

### 34.2. Przykład
```hcl
output "resource_group_name" {
  description = "Name of RG"
  value       = azurerm_resource_group.rg.name
}
```

### 34.3. Podsumowanie
Outputy to publiczny interfejs stanu – trzymaj je minimalne.

## 35. Output Values - With Count and Splat Expression
Splat ekspresje ułatwiają wydobycie listy atrybutów.

### 35.1. Przykład
```hcl
resource "random_id" "r" { count = 3 byte_length = 4 }
output "random_ids" { value = random_id.r[*].hex }
```

### 35.2. Wady
- Przy braku elementów wynik jest pustą listą – uwzględnij to w konsumentach.

### 35.3. Podsumowanie
Splat = skrócona składnia agregacji przy `count`.

## 36. Output Values - With for_each and for loops
Przy `for_each` użyj wyrażenia `for` do budowy mapy uproszczonej.
Dla map: `output "vm_ips" { value = {for k,v in azurerm_linux_virtual_machine.vm: k => v.private_ip_address} }`.

### 36.1. Przykład rozbudowany
```hcl
output "vm" {
  value = {for k,v in azurerm_linux_virtual_machine.vm: k => {
    id       = v.id
    private  = v.private_ip_address
    location = v.location
  }}
}
```

### 36.2. Podsumowanie
Elastyczne formowanie struktury outputów pod potrzeby konsumentów.

## 37. Local Values
`locals` – miejsce na powtarzalne wyrażenia, kalkulacje, wzorce nazewnictwa.

### 37.1. Przykład
```hcl
locals {
  prefix      = lower("${var.project}-${var.environment}")
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}
```

### 37.2. Dobre praktyki
- Nie wkładaj do locals wartości, które powinny być zmienną wejściową.
- Złożona logika? Rozważ moduł.

### 37.3. Podsumowanie
Poprawiają DRY – utrzymuj je proste.

## 38. Conditional Expressions
Warunki skracają wyrażenia i parametryzują konfigurację.

### 38.1. Przykład
```hcl
resource "azurerm_public_ip" "pip" {
  count = var.enable_public ? 1 : 0
  name  = var.enable_public ? "${local.prefix}-pip" : null
}
```

### 38.2. Złożone warunki
Gdy warunek staje się długi, przenieś do locals `locals { create_pip = var.enable_public && var.region == "westeurope" }`.

### 38.3. Podsumowanie
Czytelne warunki poprawiają elastyczność – unikaj gniazdowania wielu ternary.

## 39. Datasources
Data source odczytuje istniejące dane z API bez tworzenia zasobów.

### 39.1. Przykład
```hcl
data "azurerm_resource_group" "existing" { name = var.rg_name }
```

### 39.2. Dobre praktyki
- W modułach reużywalnych preferuj parametry zamiast lookup.
- Ogranicz liczbę data sources – każdy to remote call (czas planu).

### 39.3. Ryzyka
- Zmiana zewnętrznych zasobów bez kontroli – plan może się różnić zależnie od aktualnego stanu.

### 39.4. Podsumowanie
Stosuj głównie w root module do integracji z istniejącą infrastrukturą.

## 40. Backends - Remote State Storage
Backend = lokalizacja pliku stanu + mechanizmy blokady.

### 40.1. Azure Backend
- Storage Account (rekomendowane: redundancja LRS/GRS w prod).
- Container (np. `tfstate`).
- Soft delete + versioning (bezpieczeństwo utraty).
- Blob lease jako lock – zapobiega równoległym `apply`.

### 40.2. Dobre praktyki
- Oddzielne klucze dla środowisk: `env/dev.tfstate`, `env/prod.tfstate`.
- Ogranicz dostęp (RBAC + Firewall + Private Endpoint jeśli wrażliwe).
- Włącz szyfrowanie (domyślnie w Azure) + opcjonalnie CMK.

### 40.3. Typowe błędy
| Błąd | Skutek | Fix |
|------|--------|-----|
| Brak locka | Równoległe apply | Użyj zdalnego backendu zamiast lokalnego |
| Publiczny Storage bez ograniczeń | Ryzyko wycieku stanu | Włącz network rules / Private Endpoint |
| Brak backup | Utrata stanu | Soft delete + kopia zapasowa |

### 40.4. Podsumowanie
Zdalny backend = współdzielenie, bezpieczeństwo, kontrola – podstawa dojrzałego procesu.

## 41. Remote State Datasource
`terraform_remote_state` pozwala zaciągać outputy innego projektu/stanu – tworzy miękką zależność między konfiguracjami.
Pozwala odczytać outputy innego stanu:
```hcl
data "terraform_remote_state" "net" {
  backend = "azurerm"
  config = {
    storage_account_name = "tfstateprod"
    container_name       = "tfstate"
    key                  = "network.tfstate"
  }
}
```
### 41.1. Zastosowania
- Konsumpcja istniejącej sieci / VNet.
- Pobranie ID Key Vault / Log Analytics.

### 41.2. Ryzyka
- Sprzężenie między repo/projektami – trudniejsze refaktoryzacje.
- Wymagane uprawnienia do obu kont Storage / przestrzeni.

### 41.3. Alternatywy
- Przekazywanie parametrów w pipeline (artifact plan -> param injection).
- Moduł monorepo (wydzielony, wersjonowany).

### 41.4. Podsumowanie
Potężne ale tworzy zależności – rozważ ograniczenie i dokumentuj źródła.

## 42. State Commands
Komendy stanu służą do inspekcji i awaryjnych korekt.

### 42.1. Przykłady
- `terraform state list` – enumeracja zasobów.
- `terraform state show <address>` – szczegóły wybranego zasobu.
- `terraform state mv` – zmiana adresu (np. przy refaktoryzacji nazwy zasobu).
- `terraform state rm` – usunięcie zasobu ze stanu (po ręcznym skasowaniu w chmurze i chęci uniknięcia rekreacji).

### 42.2. Dobre praktyki
- Najpierw spróbuj refaktoryzacji kodu (zmiana nazwy + `terraform apply` może wystarczyć) – dopiero potem `mv`.
- Loguj zmiany w PR (opis dlaczego edycja stanu).

### 42.3. Ryzyka
- Niewłaściwe `rm` → Terraform próbuje odtworzyć zasób.
- `mv` w złe miejsce → dezorientacja zespołu.

### 42.4. Podsumowanie
State commands = narzędzia chirurgiczne – używaj świadomie.

## 43. Terraform Apply -refresh-only Command
`apply -refresh-only` synchronizuje stan z rzeczywistością bez wprowadzania zmian w zasobach.

### 43.1. Zastosowania
- Po auditowej ręcznej zmianie tagu (aby stan odzwierciedlał rzeczywistość).
- Po naprawie zasobu w portalu gdy szybka korekta była konieczna.

### 43.2. Ryzyka
- Legalizuje dryft – może zachęcać do manualnych zmian (unikaj kultury click-ops).

### 43.3. Podsumowanie
Awaryjny mechanizm synchronizacji – nie część normalnego workflow.

## 44. CLI Workspaces with local backend
Workspaces = wiele niezależnych stanów logicznych w jednym katalogu.

### 44.1. Komendy
- `terraform workspace new dev`
- `terraform workspace select dev`
- `terraform workspace list`

### 44.2. Wady (lokalny backend)
- Brak współdzielenia – pliki .tfstate per workspace lokalnie.
- Ryzyko kolizji przy kopiowaniu katalogu.

### 44.3. Alternatywa
- Oddzielne klucze backendu + pliki tfvars – bardziej jawne.

### 44.4. Podsumowanie
Lokalne workspace są wygodne do eksperymentów, nie do zespołowej produkcji.

## 45. CLI Workspaces with a remote backend
Przy zdalnym backendzie workspace tworzy unikalny klucz stanu.

### 45.1. Zalety
- Szybkie tworzenie izolowanych instancji (np. ephemeral test).

### 45.2. Wady
- Ukryta logika różnic (workspace vs. var-file) – trudniejsze dla nowych osób.
- Łatwo pomylić workspace i nieświadomie stosować produkcyjny stan.

### 45.3. Dobre praktyki
- Wyświetl aktywny workspace w CI (echo step).
- Preferuj var-files dla środowisk stabilnych.

### 45.4. Podsumowanie
Przydatne dla ephemeral – dla stałych środowisk preferuj jawne pliki tfvars.

## 46. File Provisioner
Kopiuje plik lokalny do zasobu (np. VM przez SSH).

### 46.1. Dlaczego antywzorzec
- Buduje coupling między stanem Terraform a konfiguracją systemu.
- Trudne do audytu i powtarzalności (bez testów wersji pliku).

### 46.2. Alternatywy
- Cloud-init, DSC, Ansible, Chef.
- Pobranie z Storage / Git release.

### 46.3. Podsumowanie
Unikaj – zastąp natywnymi mechanizmami inicjalizacji.

## 47. local-exec Provisioner
Uruchamia komendy lokalnie (na hostcie wykonującym Terraform).

### 47.1. Zastosowania minimalne
- Powiadomienie webhook (opcjonalne, lepiej integracja w pipeline).
- Tymczasowa diagnostyka (rzadko, usuń przed commit).

### 47.2. Ryzyka
- Zależność od środowiska lokalnego (narzędzia, PATH).
- Brak idempotencji (komenda może mieć skutki uboczne).

### 47.3. Podsumowanie
Stosuj skrajnie rzadko – przenieś logikę do CI/CD.

## 48. remote-exec Provisioner
Uruchamia komendy bezpośrednio na zasobie (SSH/WinRM).

### 48.1. Wady
- Wysoka podatność na błędy sieciowe.
- Trudne testy regresji.
- Utrudniona rotacja kluczy / dostępów.

### 48.2. Alternatywy
- Cloud-init (Linux), VM Extensions (Azure), konfiguracja po wdrożeniu przez narzędzie dedykowane.

### 48.3. Podsumowanie
Nie stosuj w długoterminowych produkcyjnych configach.

## 49. Null Resource
`null_resource` – pseudo-zasób służący jako kotwica dla provisionerów / triggerów.

### 49.1. Ryzyka
- Zwiększa złożoność grafu bez korzyści infrastrukturalnych.
- Trudno śledzić jego wpływ w planie.

### 49.2. Alternatywy
- CI/CD pipeline tasks.
- Moduły generujące dane przez wyrażenia (locals).

### 49.3. Podsumowanie
Unikaj – jeśli potrzebujesz, zwykle design można uprościć.

## 50. State Import
`terraform import` mapuje istniejący zasób w chmurze do stanu Terraform.

### 50.1. Proces
1. Identyfikacja zasobu (ID / nazwa / ścieżka).
2. `terraform import azurerm_resource_group.rg /subscriptions/xxx/resourceGroups/rg-name`.
3. Dodanie HCL odwzorowującego parametry zasobu.
4. `plan` aby upewnić się, że brak niechcianych zmian.

### 50.2. Dobre praktyki
- Dokumentuj w PR powód migracji.
- Grupuj importy – nie rób masowo w chaosie.

### 50.3. Ryzyka
- Niepełna definicja po imporcie → terraform może próbować zmienić zasób.

### 50.4. Podsumowanie
Import = etap migracji do IaC, nie codzienny sposób zarządzania.

## 51. Modules from Public Registry
Public Registry = centralne źródło modułów (community + Azure Verified Modules (AVM)).

### 51.1. Kryteria wyboru
- Liczba wersji + ostatnia aktualizacja.
- README z przykładami.
- Brak ostrzeżeń o deprecated providerach.
- Testy (Terratest / CI badge).

### 51.2. Pinowanie
```hcl
module "vnet" {
  source  = "Azure/vnet/azurerm"
  version = "~> 3.0"
  # ...
}
```

### 51.3. Ryzyka
- Nadmierne poleganie na module bez zrozumienia jego outputów.

### 51.4. Podsumowanie
Wybieraj moduły wspierane i przejrzyste – AVM preferowane gdzie dostępne.

## 52. Terraform Azure Static Website
Static Website = funkcja Storage Account wystawiająca pliki z kontenera `$web`.

### 52.1. Kroki
1. Tworzenie Storage Account (`static website` feature).
2. Ustawienie index/error doc.
3. Deployment plików (poza Terraform – np. az CLI / CI job).
4. (Opcjonalnie) Azure CDN / Front Door.
5. (Bezpieczeństwo) Private Endpoint + WAF gdy potrzeba.

### 52.2. Przykład fragmentu
```hcl
resource "azurerm_storage_account" "site" {
  name                     = local.prefix
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}
```

### 52.3. Dobre praktyki
- Wersjonuj pliki strony (artifact build).
- Włącz HTTPS wymuszony na CDN.

### 52.4. Podsumowanie
Lekki hosting – nie mieszaj deploymentu plików z provisioningiem infrastruktury.

## 53. Build Local Module
Moduł lokalny = folder z jasno zdefiniowanymi interfejsami wejścia/wyjścia.
Struktura: `modules/<nazwa>/main.tf variables.tf outputs.tf`. Celem: reużywalność, enkapsulacja. 

### 53.1. Kroki tworzenia
1. Identyfikacja powtarzalnego wzorca (np. NSG + reguły).
2. Definicja wejść (typy, walidacje).
3. Definicja outputów minimalnych.
4. Dodanie README z przykładami.

### 53.2. Dobre praktyki
- Brak `data` źródeł dla zasobów zewnętrznych – parametryzuj.
- Waliduj region / naming.
- Dodaj `required_version` w root, nie w module.

### 53.3. Podsumowanie
Moduł to kontrakt – dbaj o jego prostotę i dokumentację.

## 54. Publish Modules to Terraform Public Registry
Publikacja = repozytorium publiczne + poprawna struktura + tagi semver.

### 54.1. Wymagania
- Repo nazwa: `terraform-<provider>-<module>` (rekomendowana konwencja).
- Tagowanie: `v1.0.0`, `v1.1.0`.
- README z sekcją Inputs/Outputs + przykłady.
- LICENSE (preferuj MIT / Apache 2.0).

### 54.2. Proces aktualizacji
- Zmiany kompatybilne: minor.
- Breaking: major + CHANGELOG wyjaśniający migrację.

### 54.3. Podsumowanie
Profesjonalne moduły publikuj z jasnym versioningiem i dokumentacją.

## 55. Module Sources
Źródła modułów definiują skąd Terraform pobiera kod.

### 55.1. Typy
- Lokalny: `source = "./modules/network"`.
- Registry: `Azure/vnet/azurerm`.
- Git: `git::https://github.com/org/repo.git//path?ref=v1.2.0`.
- Archiwum: `https://.../module.zip`.

### 55.2. Dobre praktyki
- Pinuj `ref` w Git – unikaj `main` (dryft).
- Utrzymuj spójność wersji między środowiskami.

### 55.3. Podsumowanie
Kontroluj źródła i wersje – reprodukowalność jest krytyczna.

## 56. Terraform Cloud - VCS-Driven Workflow
Integracja z VCS (GitHub/Azure DevOps) automatyzuje plan przy push/PR.

### 56.1. Zalety
- Centralny audit planów.
- Sekrety przechowywane jako vars (nie w repo).
- Sentinel policy enforcement.

### 56.2. Flow
Commit → Hook → Plan → Manual Apply (opcjonalny) → Post-deploy checks.

### 56.3. Podsumowanie
VCS workflow = standaryzacja i governance w jednym miejscu.

## 57. Terraform Cloud - CLI-Driven Workflow
CLI-driven: lokalny `terraform` steruje zdalną egzekucją.

### 57.1. Konfiguracja
Blok `cloud { organization = "org" workspaces { name = "app-prod" } }`.

### 57.2. Zalety
- Szybszy dostęp do wyników (lokalne narzędzia + zdalna moc obliczeniowa).

### 57.3. Ryzyka
- Wymaga poprawnych tokenów w ~/.terraform.d/credentials.tfrc.json.

### 57.4. Podsumowanie
Łączy wygodę lokalną ze spójnością zdalną.

## 58. Terraform Cloud - Share modules in private module registry
Prywatny registry = kontrola dostępu + standaryzacja.

### 58.1. Zalety
- Jedno źródło prawdy modułów organizacyjnych.
- Szybkie wdrażanie poprawek bezpieczeństwa.

### 58.2. Dobre praktyki
- Semver + CHANGELOG.
- Automatyczne testy modułu przed publikacją.

### 58.3. Podsumowanie
Buduje wewnętrzny ekosystem IaC – inwestycja w skalę.

## 59. Migrate State to Terraform Cloud
Migracja przenosi plik stanu z lokalnego / innego backendu do Terraform Cloud.

### 59.1. Kroki
1. Dodaj blok `cloud {}`.
2. `terraform init -migrate-state`.
3. Walidacja poprawności (lista zasobów).
4. Usuń stary plik lokalny / zarchiwizuj.

### 59.2. Dobre praktyki
- Zrób backup przed migracją.
- Sprawdź role użytkowników (least privilege).

### 59.3. Podsumowanie
Migracja zwiększa bezpieczeństwo i audit – wykonuj kontrolowane.

## 60. Basic Sentinel & Cost Control Policies
Sentinel = policy-as-code w Terraform Cloud.

### 60.1. Przykłady polityk
- Wymuszenie tagów.
- Limit dozwolonych SKU VM (koszt kontrola).
- Blokada tworzenia publicznych IP w prod bez wyjątku.

### 60.2. Cykl życia polityki
1. Definicja (HCL/JSON styl w Sentinel DSL).
2. Testy (mock plan JSON).
3. Deploy do workspace policy set.
4. Monitor odrzuconych planów dla ewolucji.

### 60.3. Podsumowanie
Sentinel nakłada strażniki kosztów i zgodności – uzupełnienie testów i lintów.

## 61. Foundational Sentinel Policies
Fundament zestawu polityk – minimalne standardy organizacyjne.

### 61.1. Przykłady
- Mandatory tags (Environment, CostCenter, Owner).
- Allowed regions whitelist.
- Wymuszenie szyfrowania (np. `enable_https_traffic_only` dla Storage).
- Blokada public access dla Storage / DB.

### 61.2. Warstwowanie
- Base policies (tagi, regiony).
- Security policies (public access, firewall rules).
- Cost policies (SKU limity).

### 61.3. Podsumowanie
Warstwa podstawowa polityk blokuje większość typowych naruszeń compliance.

## 62. Dynamic Blocks
Dynamic blocks generują powtarzalne sekcje konfiguracji na podstawie kolekcji.
Pozwalają generować powtarzalne bloki z kolekcji:
```hcl
dynamic "security_rule" {
  for_each = var.rules
  content {
    name                       = security_rule.key
    priority                   = security_rule.value.priority
    direction                  = "Inbound"
    access                     = security_rule.value.access
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = security_rule.value.port
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```
### 62.1. Zastosowania
- NSG rules, blok `ip_configuration`, `backend_address_pool`, `access_policy`.

### 62.2. Dobre praktyki
- Umieść dane sterujące w mapach/obiektach.
- Sortuj priorytety dla deterministycznego planu (opcjonalnie poprzez przygotowanie kolekcji w locals).

### 62.3. Ryzyka
- Nadmierna logika w jednym dynamic block → trudne debugowanie.

### 62.4. Podsumowanie
Zwiększa DRY – używaj czytelnych danych wejściowych.

## 63. Terraform Debug
Mechanizmy diagnostyczne pomagają analizować problemy wydajności/grafu.

### 63.1. Zmienne
- `TF_LOG=TRACE|DEBUG|INFO|WARN|ERROR`.
- `TF_LOG_PATH=terraform.log` – zapis do pliku.

### 63.2. Dobre praktyki
- Włączaj na krótko podczas lokalnego debug.
- Nie commituj plików log.

### 63.3. Podsumowanie
Silne narzędzie – używaj oszczędnie aby nie zanieczyszczać pipeline.

## 64. Override Files
`*_override.tf` pozwalają nadpisać istniejące definicje – historycznie używane, dziś rzadko zalecane.

### 64.1. Ryzyka
- Ukryte źródło zmian – trudne code review.
- Niespójność z głównymi plikami.

### 64.2. Alternatywy
- Refaktoryzacja modułu.
- Parametryzacja / var-files.

### 64.3. Podsumowanie
Unikaj – jawny kod lepszy do utrzymania.

## 65. External Provider Basic Demo
Provider `external` wykonuje program lokalny i interpretuje jego wynik JSON.
Provider `external` wykonuje skrypt zwracający dane JSON. Użycie:
```hcl
data "external" "example" {
  program = ["python3", "script.py"]
}
```
### 65.1. Ryzyka
- Zależność od wersji interpreterów.
- Brak idempotencji jeśli skrypt ma skutki uboczne.

### 65.2. Podsumowanie
Stosuj gdy brak natywnego providera – monitoruj stabilność.

## 66. External Provider Integrated Demo
Zaawansowane użycie: pobranie zewnętrznych danych (lista IP, konfiguracja polityk) i wstrzyknięcie do zasobów.

### 66.1. Alternatywy
- Oficjalne API providera.
- Pre-processing w pipeline generujący plik `auto.tfvars.json`.

### 66.2. Podsumowanie
External rozszerza możliwości – minimalizuj aby nie budować kruchego łańcucha zależności.

## 67. CLI Config File on macOS and Linux
Pliki konfiguracyjne sterują credentialami, mirrorami, ustawieniami providera.

### 67.1. Lokalizacje
- `~/.terraformrc` (starsze) lub `~/.terraform.d/credentials.tfrc.json`.

### 67.2. Bezpieczeństwo
- Prawa tylko dla użytkownika (`chmod 600`).
- Tokeny rotowane okresowo.

### 67.3. Podsumowanie
Dbaj o właściwe uprawnienia pliku – zawiera wrażliwe dane.

## 68. CLI Config File on WindowsOS
Ścieżka: `%APPDATA%\terraform.rc` lub `%APPDATA%\terraform.d\credentials.tfrc.json`.

### 68.1. Dobre praktyki
- Użyj PowerShell do ustawiania tokenów (nie zapisuj w plain echo).
- Sprawdź ACL – tylko użytkownik.

### 68.2. Podsumowanie
Analogiczne zasady jak Linux – różni się ścieżka i prawa dostępu.

## 69. Manage Providers
Kontrola providerów = stabilność i bezpieczeństwo.

### 69.1. Mirror Registry
- Konfiguracja mirroru aby uniknąć zależności od internetu (air-gapped).
- Poprzez `provider_installation` w `.terraformrc`.

### 69.2. Aktualizacje
- Testuj w dev: `init -upgrade` + plan.
- Przegląd release notes (breaking changes).

### 69.3. Podsumowanie
Świadome zarządzanie wersjami minimalizuje ryzyko awarii po aktualizacji.

## 70. Terraform Functions
Funkcje wspierają przekształcanie danych – stringi, kolekcje, typy, sieciowe.
Bogaty zestaw funkcji do transformacji danych i składania struktur. Łączone często z dynamic blocks i for expressions. Dobre praktyki: upraszczaj skomplikowane wyrażenia poprzez locals.

### 70.1. Kategorie
- String: `lower`, `replace`, `substr`.
- Kolekcje: `keys`, `values`, `concat`, `merge`, `zipmap`.
- Typy: `toset`, `tolist`, `tomap`, `tostring`.
- Logika: `can`, `try`, `coalesce`, `coalescelist`.
- Kryptografia: `base64encode`, `base64decode`.
- Sieciowe: `cidrsubnet`, `cidrhost` (dla kalkulacji podsieci).

### 70.2. Dobre praktyki
- Złożone wyrażenia (gniazdowanie wielu funkcji) → przenieś do locals.
- Waliduj wyniki (nazwa, długość, listy) przed użyciem w zasobach.

### 70.3. Podsumowanie
Funkcje zwiększają ekspresję HCL – czytelność przed złożonością.

---
# Funkcje Terraform użyte (Opis i przykłady)

## 1. element
Zwraca element listy wg indeksu (obsługa zawijania przy modulo). `element(["a","b"], 1) => "b"`. Uważaj: przy zmianie długości listy może zwrócić inne wartości przy wyższych indeksach.

## 2. file
Wczytuje zawartość pliku tekstowego jako string. Użycie: `file("cloud-init.yaml")`. Nie dla binarnych.

## 3. filebase64
Czyta plik i zwraca jego zawartość w Base64 (przydatne w customData VM). `filebase64("init.sh")`.

## 4. toset
Konwertuje listę na set (usuwa duplikaty, nie gwarantuje kolejności). Użyte do `for_each` stabilizacji adresów gdy wartości unikalne.

## 5. length
Zwraca długość listy, mapy, stringa. Przydatne do warunków `count = length(var.items) > 0 ? 1 : 0`.

## 6. lookup
Czyta wartość z mapy z domyślną fallback: `lookup(var.map, "key", "default")`. Zapobiega błędom braku klucza.

## 7. substr
Zwraca fragment stringa: `substr("abcdef", 0, 3) => "abc"`. Użyte np. skróty regionów.

## 8. contains
Sprawdza czy lista zawiera element: `contains(["a","b"], "b") => true`. Walidacja regionów.

## 9. lower
Zamienia tekst na małe litery: `lower(var.name)`. Spójność nazw zasobów w Azure.

## 10. upper
Zamienia na wielkie litery. Rzadziej używane – czasem w tagach.

## 11. regex
Wyrażenie regularne – match. Użycie do walidacji naming conventions. `regex("^[a-z0-9-]+$", var.name)`.

## 12. can
Sprawdza czy wyrażenie nie wywoła błędu: `can(regex(...))`. Użyte cały wzorzec `can` + `try` od Terraform 1.3+.

## 13. keys
Zwraca listę kluczy mapy. Pomocne w budowie dynamicznych struktur: `for k in keys(var.map)`.

## 14. values
Zwraca listę wartości mapy. Użyte do filtrowania lub agregacji.

## 15. sum
Sumowanie elementów listy liczb: `sum([1,2,3]) => 6`. Często w obliczeniach kosztów lub alokacji.

---
## Dodatkowe dobre praktyki (Podsumowanie)
- Nie przechowuj sekretów: używaj Key Vault lub zmiennych w Terraform Cloud.
- Utrzymuj spójne tagowanie i nazewnictwo.
- Waliduj dane wejściowe – unikniesz niepoprawnych regionów.
- Zanim wprowadzisz dynamic blocks – rozważ czy statyczny kod nie będzie czytelniejszy.
- Planuj izolację środowisk poprzez pliki tfvars i backend key, nie przez oddzielne repozytoria.

## Typowe pułapki
- Nadmiar `depends_on` – niepotrzebnie komplikuje graf zależności.
- Używanie provisionerów zamiast natywnych mechanizmów inicjalizacji.
- Brak kontroli wersji providerów.
- Mieszanie logiki warunkowej w wielu miejscach zamiast prostych locals.

---
Dokument gotowy do dalszego rozszerzania.
