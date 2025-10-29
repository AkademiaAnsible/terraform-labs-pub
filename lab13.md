# Lab 13: Azure Key Vault i Sekrety

## Cel
Utworzyć Azure Key Vault, dodać do niego sekret poprzez Terraform i zrozumieć dobre praktyki bezpiecznego zarządzania tajnymi danymi:
- Konfiguracja `azurerm_key_vault` z RBAC / purge protection.
- Dodanie zasobu `azurerm_key_vault_secret` bez wypisywania wartości w outputach.
- Ograniczenia i ryzyka: przechowywanie wartości w stanie Terraform.

## Dlaczego Key Vault?
Centralne przechowywanie kluczy, haseł, connection stringów z kontrolą dostępu i audytem. Lepsze niż trzymanie sekretów w zmiennych lub plikach.

## Kluczowe parametry Key Vault
| Parametr | Znaczenie | Zalecenie |
|----------|-----------|-----------|
| `purge_protection_enabled` | Blokada trwałego usunięcia | Włącz w środowisku produkcyjnym |
| `soft_delete_retention_days` | Okres odzyskiwania | 7–90 dni wg polityki |
| `enable_rbac_authorization` | RBAC zamiast access policies | Preferowane (jedna płaszczyzna uprawnień) |
| `public_network_access_enabled` | Dostęp publiczny | Rozważ wyłączenie + Private Endpoint |
| `sku_name` | Standard/Premium | Standard wystarczający dla sekretów |

## Przykładowa konfiguracja Terraform
```hcl
resource "azurerm_key_vault" "kv" {
  name                = "${var.project}-${var.environment}-kv"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  enable_rbac_authorization   = true
  purge_protection_enabled    = true
  soft_delete_retention_days  = 30
  public_network_access_enabled = true

  tags = var.tags
}

resource "azurerm_key_vault_secret" "example" {
  name         = "app-password"
  value        = var.app_password  # Zmienna oznaczona jako sensitive
  key_vault_id = azurerm_key_vault.kv.id
  content_type = "text/plain"
}

variable "app_password" {
  description = "Hasło aplikacyjne przechowywane w Key Vault"
  type        = string
  sensitive   = true
}

data "azurerm_client_config" "current" {}
```

## Kroki
1. Przejdź do katalogu `lab13` (lub utwórz jeśli nie istnieje) i dodaj powyższe fragmenty do `main.tf` / `variables.tf`.
2. Ustaw wartość hasła: np. w `dev.tfvars` → `app_password = "superTajneHaslo123!"` (NIE commituj prawdziwych sekretów w repo).
3. `terraform init`
4. `terraform plan` – weryfikacja utworzenia Key Vault + sekretu.
5. `terraform apply`
6. W Portalu / CLI sprawdź sekret:
   ```bash
   az keyvault secret show --vault-name <nazwa_kv> --name app-password --query value -o tsv
   ```
   (W CI/CD unikaj wyświetlania wartości; to tylko test lokalny.)

## Weryfikacja
- Key Vault istnieje w Resource Group.
- Sekret widoczny w Key Vault (nie w outputach Terraform).
- Purge protection aktywna (jeśli środowisko produkcyjne).
- Brak jawnych wartości w kodzie repo.

## Dobre praktyki bezpieczeństwa
- Nie wypisuj sekretów w `output` (prowadzi do utrwalenia w stanie + ekspozycji).
- Używaj Managed Identity dla dostępu z aplikacji zamiast pobierania sekretów w build time.
- Ogranicz liczbę osób mających rolę Key Vault Secrets Officer / Administrator.
- Włącz diagnostykę i logowanie dostępu (Diagnostic Settings → Log Analytics) dla audytu użycia.
  ```hcl
  resource "azurerm_monitor_diagnostic_setting" "kv" {
    name                       = "kv-diag"
    target_resource_id         = azurerm_key_vault.kv.id
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

    enabled_log {
      category = "AuditEvent"
    }
  }
  ```
- Rozważ Private Endpoint i wyłączenie publicznej sieci dla produkcji.

## Uwaga o stanie Terraform
Wartość sekretu (`value`) trafia do pliku stanu Terraform. Oznacz zmienną jako `sensitive`, ale to NIE ukrywa jej w stanie—jedynie w outputach i UI. Aby ograniczyć ekspozycję:
- Trzymaj backend w zabezpieczonym Storage z RBAC.
- Rozważ generowanie sekretu poza Terraform i tylko referencję (data source) jeśli scenariusz wymaga.

## Typowe problemy
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| Brak dostępu do sekretu | RBAC nie przypisane | Dodaj rolę "Key Vault Secrets User" dla tożsamości |
| Błąd tworzenia sekreta po wyłączeniu public network | Brak Private Endpoint | Utwórz private endpoint lub włącz publiczny dostęp |
| Niemożność trwałego usunięcia | Purge protection on | W środowisku testowym wyłącz lub zaakceptuj opóźnienie |
| Plan pokazuje zmianę secretu przy każdej edycji | Zmienna zmieniona | Akceptuj – aktualizacja wartości sekretu jest zamierzona |

## Rozszerzenia
- Dodaj rotację sekretu (skrypt generujący losową wartość przy każdym deploy w środowisku testowym).
- Wdróż certyfikat (`azurerm_key_vault_certificate`) zamiast prostego sekretu.
- Eksportuj audyt do Event Hub / SIEM.

## Sprzątanie
Przy aktywnej purge protection usunięcie Key Vault → soft delete; pełne usunięcie wymaga dodatkowych kroków (CLI). W labie możesz pozostawić w celu wykorzystania w kolejnych ćwiczeniach.

## Checklist końcowa
- [ ] Utworzony Key Vault z poprawnymi parametrami
- [ ] Sekret dodany i możliwy do odczytu (kontrolowany dostęp)
- [ ] Brak sekretu w outputach Terraform
- [ ] Purge protection (zgodnie z polityką) skonfigurowana
- [ ] Audyt (diagnostic setting) dodany lub zaplanowany

## Następny krok
Lab 14 rozszerza podejście o bardziej zaawansowane wzorce (np. moduły, agregacje, moved blocks) – możesz tam przenieść Key Vault do modułu.
