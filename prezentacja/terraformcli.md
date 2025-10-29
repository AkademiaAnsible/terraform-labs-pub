# Terraform CLI – Komendy i Przykłady (Terraform v1.x)

Dokument zawiera opis najważniejszych komend Terraform CLI wraz z praktycznymi przykładami (skupienie na Azure), dobrymi praktykami i ostrzeżeniami. Wersja oparta na aktualnej dokumentacji (v1.13+/v1.14 beta uwzględnione w notatkach).

---
## Podstawowy workflow
Najczęściej używane komendy w codziennej pracy:
1. `terraform init` – inicjalizacja katalogu roboczego.
2. `terraform validate` – walidacja syntaktyczna i podstawowa.
3. `terraform plan` – podgląd planowanych zmian.
4. `terraform apply` – wykonanie zmian.
5. `terraform destroy` – usunięcie zarządzanych zasobów.

---
## Globalne opcje
Można użyć przed nazwą komendy:
- `-chdir=DIR` – uruchom komendę, zmieniając katalog roboczy.
- `-help` – pomoc ogólna lub dla subkomendy.
- `-version` – wersja Terraform.

Przykład:
```bash
terraform -chdir=lab1 plan
```

---
## `terraform init`
Inicjalizuje katalog (instaluje providerów, moduły, backend).

Przykład:
```bash
terraform init
terraform init -upgrade
terraform init -backend-config=backend.hcl
```
Wybrane opcje:
- `-upgrade` – aktualizacja providerów i modułów wg constraintów.
- `-backend-config=FILE` – częściowa konfiguracja backendu (np. dynamiczne wartości).
- `-reconfigure` – ignoruje istniejące ustawienia backendu.
- `-migrate-state` / `-force-copy` – migracja stanu do nowego backendu.
- `-from-module=ŹRÓDŁO` – skopiowanie modułu do pustego katalogu.

Dobra praktyka: Commmituj plik lock (`.terraform.lock.hcl`). Nie usuwaj katalogu `.terraform` ręcznie – odtwarzaj przez `init`.

---
## `terraform validate`
Sprawdza poprawność składni i podstawową spójność. Nie wykonuje połączeń do API.
```bash
terraform validate
```
Uwaga: Nie wykrywa błędnych nazw typów zasobów lub braków dostępnych dopiero w runtime – to wychodzi w `plan`.

---
## `terraform plan`
Generuje plan wykonania – pokazuje co zostanie utworzone / zmienione / usunięte.

Przykład podstawowy:
```bash
terraform plan
```
Z zapisaniem planu:
```bash
terraform plan -out=tfplan
```
Tryby specjalne:
- `-destroy` – plan destrukcyjny.
- `-refresh-only` – tylko odświeżenie stanu (bez zmian w infrastrukturze).

Opcje istotne:
- `-var 'location="West Europe"'` – pojedyncza wartość.
- `-var-file=dev.tfvars` – plik wartości.
- `-target=adres.zasobu` – (TYLKO awaryjnie) skup się na części infrastruktury.
- `-replace=adres.zasobu` – wymusza odtworzenie konkretnej instancji.
- `-parallelism=NUM` – liczba równoległych operacji (domyślnie 10).
- `-detailed-exitcode` – zwraca: 0 brak zmian, 2 są zmiany, 1 błąd.

Azure przykład z wymuszeniem replace:
```bash
terraform plan -replace=azurerm_storage_account.sa -out=tfplan
```

Ostrzeżenie: Nadużycie `-target` powoduje dryft – lepiej dzielić konfiguracje na moduły/projekty.

---
## `terraform apply`
Wykonuje plan i zmienia infrastrukturę.

Przykład prosty (z nowym planem):
```bash
terraform apply
```
Z użyciem wcześniej zapisanego planu:
```bash
terraform apply tfplan
```
Opcje:
- `-auto-approve` – bez pytania o potwierdzenie.
- Opcje planu (gdy bez pliku `tfplan`) – np. `-replace`, `-var-file`.
- `-parallelism=N` – limit równoległych zmian.

Bezpieczeństwo: Nigdy nie używaj `-auto-approve` w produkcji bez wcześniejszego zatwierdzonego planu w CI/CD.

---
## `terraform destroy`
Alias dla `terraform apply -destroy`. Usuwa wszystkie zasoby zarządzane.

Przykład:
```bash
terraform destroy
terraform destroy -target=azurerm_resource_group.rg  # selektywnie (ostrożnie)
```
Zastosowanie: Sprzątanie środowisk testowych / ephemeral.

---
## `terraform fmt`
Formatuje kod do stylu Terraform.
```bash
terraform fmt
terraform fmt -recursive
```
Najlepiej używać w pre-commit hook.

---
## `terraform console`
Interaktywna konsola do testowania wyrażeń.
```bash
terraform console
> var.location
> cidrsubnet("10.0.0.0/16", 4, 2)
```
Przydatne do sprawdzania locals, funkcji, referencji do stanu.

---
## `terraform show`
Pokazuje aktualny stan lub zapisany plan.
```bash
terraform show
terraform show -json tfplan > plan.json
```
Uwaga: Eksport JSON może zawierać dane wrażliwe.

---
## `terraform output`
Wyświetla outputy root modułu.
```bash
terraform output
terraform output resource_group_name
terraform output -json > outputs.json
```
Wrażliwe outputy będą oznaczone jako `sensitive`.

---
## `terraform state` (podkomendy)
Zaawansowane operacje na stanie. Używać ostrożnie – łatwo o dryft.
Podstawowe:
- `terraform state list` – lista adresów zasobów.
- `terraform state show adres.zasobu` – szczegóły instancji.
- `terraform state mv old new` – przeniesienie wpisu (np. refaktoryzacja nazw).
- `terraform state rm adres.zasobu` – usunięcie wpisu (nie niszczy zasobu!).
- `terraform state pull` / `push` – ręczne pobranie/wysłanie stanu (niezalecane w workflow CI/CD).

Przykład refaktoryzacji:
```bash
terraform state mv azurerm_resource_group.rg module.core.azurerm_resource_group.rg
```

---
## `terraform import`
Mapuje istniejący zasób do konfiguracji Terraform.
```bash
terraform import azurerm_resource_group.rg /subscriptions/XXXX/resourceGroups/myrg
```
Po imporcie trzeba dopisać odpowiedni blok `resource` – inaczej dryft przy kolejnych planach.

---
## `terraform graph`
Generuje graf zależności (Graphviz DOT):
```bash
terraform graph | dot -Tpng > graph.png
```
Przydatne do analizy kolejności tworzenia.

---
## `terraform get`
Pobiera/aktualizuje moduły zdefiniowane w `module`.
```bash
terraform get
terraform get -update
```
Często niepotrzebne ręcznie – `init` wykonuje to automatycznie.

---
## `terraform providers`
Lista providerów wymaganych przez konfigurację.
```bash
terraform providers
terraform providers lock -platform=linux_amd64 -platform=windows_amd64
```
`providers lock` – generuje/aktualizuje lock file z checksumami.

---
## `terraform login` / `logout`
Logowanie do Terraform Cloud / innych hostów (zapisywane w `~/.terraform.d/credentials.tfrc.json`).
```bash
terraform login app.terraform.io
terraform logout app.terraform.io
```
Nie dotyczy pracy wyłącznie lokalnej z Azure.

---
## `terraform version`
Pokazuje wersję oraz informację o dostępnych aktualizacjach.
```bash
terraform version
```
Można wyłączyć Checkpoint przez `CHECKPOINT_DISABLE=1`.

---
## `terraform workspace`
Zarządzanie wieloma workspace'ami (tylko backend lokalny lub kompatybilny).
```bash
terraform workspace list
terraform workspace new dev
terraform workspace select dev
terraform workspace delete old
```
Lepsza praktyka w Azure: jeden state per środowisko przez osobne backendy / kontenery zamiast workspace.

---
## `terraform force-unlock`
Odblokowuje ręcznie zablokowany stan (np. po utracie sesji).
```bash
terraform force-unlock LOCK_ID
```
Uwaga: Upewnij się, że żadna inna operacja nie trwa – inaczej korupcja stanu.

---
## `terraform taint` / `untaint` (legacy podejście)
Oznacza zasób do ponownego utworzenia. Od wersji nowszych preferuj `-replace` w `plan`.
```bash
terraform taint azurerm_linux_virtual_machine.vm
terraform untaint azurerm_linux_virtual_machine.vm
```
Stan docelowy: używać tylko jeśli brak możliwości zastosowania `-replace`.

---
## Autocomplete
Instalacja:
```bash
terraform -install-autocomplete
```
Deinstalacja:
```bash
terraform -uninstall-autocomplete
```

---
## JSON Output
Większość komend (`plan`, `apply`, `show`) ma opcję `-json` – przydatne w automatyzacji (parsowanie wyników w CI/CD). Wymaga braku interaktywnych pytań.

---
## Dobre praktyki (Azure)
- Używaj `plan -out` + review w PR zanim `apply` w CI.
- Nigdy nie używaj `-auto-approve` w ręcznych sesjach na prod.
- Oddziel środowiska przez różne kontenery/storage backend – nie przez workspace.
- Kommituj `.terraform.lock.hcl` aby zachować spójność providerów.
- Ogranicz użycie `state rm` – preferuj poprawki w kodzie + `apply`.
- Monitoruj dryft – okresowy `plan` w trybie readonly (np. przez pipeline nocny).

---
## Szybka ściąga
| Cel | Komenda |
|-----|---------|
| Inicjalizacja | `terraform init` |
| Formatowanie | `terraform fmt -recursive` |
| Walidacja | `terraform validate` |
| Podgląd zmian | `terraform plan -out=tfplan` |
| Wdrożenie | `terraform apply tfplan` |
| Usunięcie | `terraform destroy` |
| Outputy | `terraform output -json` |
| Import istniejącego | `terraform import <addr> <id>` |
| Migracja backendu | `terraform init -migrate-state` |
| Odświeżenie stanu | `terraform plan -refresh-only` |
| Wymuszenie rekreacji | `terraform plan -replace=<addr>` |

---
## Najczęstsze błędy i ostrzeżenia
- "Provider registry unavailable" – brak sieci / proxy; rozważ mirror providerów.
- "Locked state" – odczekaj lub użyj `force-unlock` (ostrożnie).
- "No changes" – konfiguracja zgodna ze stanem; sprawdź czy wartości wejściowe są poprawne.
- Dryft: zasób zmieniony poza Terraform – wykryjesz w `plan`; napraw przez aktualizację HCL lub ręczny import.

---
## Odniesienia
- Oficjalna dokumentacja: https://developer.hashicorp.com/terraform/cli/commands
- Style: `terraform fmt` + konwencje.
- Backend i stan: patrz `backend` + Azure Storage (blob + lock przez Lease).

---
**Uwaga:** Funkcja `-invoke` opisana w dokumentacji beta (v1.14) może zostać zmieniona – nie używaj w produkcji bez potwierdzenia stabilności.

Koniec.
