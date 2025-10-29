# Lab 6: Advanced – dynamic, import, debug, state, locals

## Cel
Poznasz:
- dynamic blocks na przykładzie `azurerm_network_security_group`
- import istniejącego zasobu `terraform import`
- debugowanie Terraform i backendu (`TF_LOG`, `TF_LOG_PATH`)
- `terraform state show` oraz użycie `locals`

## Pliki
- lab6/backend.tf – backend + providers
- lab6/variables.tf – wejścia (w tym lista `security_rules`)
- lab6/locals.tf – nazwy i tagi
- lab6/main.tf – NSG z dynamic `security_rule`, RG (data lub resource)
- lab6/outputs.tf – przydatne wartości
- lab6/dev.tfvars – przykładowe wartości
- lab6/skrypt.sh – init/plan/apply z opcją -f i debug przez env

## Kroki
1) Przygotowanie
- Ustaw subskrypcję i zaloguj się w Azure CLI.
- Opcjonalnie ustaw backend przez zmienne środowiskowe w `terraform init -reconfigure`.

2) Dynamic block (NSG)
- Zmodyfikuj `dev.tfvars` i dodaj/usuń reguły w `security_rules`.
- Uruchom plan i apply, zobacz różnice.

3) Import zasobu (resource group)
- Utwórz wcześniej RG (np. przez portal lub az CLI) i ustaw `import_existing_rg_name` w tfvars.
- Najpierw zaadresuj w kodzie RG jako `data.azurerm_resource_group.existing[0]` (już jest), aby kod odczytywał istniejący RG.
- Jeśli chcesz dodać istniejący RG do stanu jako resource (pokazowo), tymczasowo ustaw `resource_group_name` na tę nazwę i ustaw `count = 1` (w tym labie RG resource jest warunkowy). Następnie uruchom:

Optional – pokaż import (nie zalecane jako stały workflow):
- Zidentyfikuj adres: `azurerm_resource_group.rg[0]`
- Wykonaj import: `terraform import azurerm_resource_group.rg[0] /subscriptions/<SUB>/resourceGroups/<RGNAME>`
- Uruchom `terraform plan` – zwróć uwagę na różnice (drift), ewentualnie skoryguj konfigurację.

4) Debug TF i backend
- Ustaw zmienne środowiskowe i uruchom skrypt:
  - `TF_LOG=TRACE TF_LOG_PATH=./tf.log ./skrypt.sh -f dev.tfvars` 
- Przejrzyj `tf.log` (szukaj `backend/remote` i operacji `state`), usuń plik po sesji.

5) State show i locals
- `terraform state show azurerm_network_security_group.nsg`
- Otwórz `locals.tf` i sprawdź jak `coalesce` i `try` wpływają na wartości nazw.

6) Sprzątanie
- `terraform destroy` (pamiętaj o backendzie i zasobach importowanych – usuń ręcznie, jeśli niezarządzane).

## Notatki
- Import to narzędzie doraźne. Preferuj deklaratywne zarządzanie zasobami.
- Nie zapisuj sekretów w stanie. Używaj Key Vault lub Managed Identity.
- Zmienna `security_rules` używa pól optional; `try()` i `coalesce()` porządkują wartości domyślne.
