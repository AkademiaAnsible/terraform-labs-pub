# Lab 14: Użycie Sekretu z Azure Key Vault jako Hasła VM

## Cel
Pobrać sekret z Azure Key Vault i wykorzystać go jako hasło administratora przy tworzeniu maszyny wirtualnej (Linux/Windows) w Azure poprzez Terraform. Zrozumieć konsekwencje bezpieczeństwa i alternatywy (SSH keys, Managed Identity).

## Założenia wstępne
- Masz utworzony Key Vault i sekret (Lab 13) o nazwie `app-password`.
- Masz istniejącą Resource Group.
- Używasz providera `azurerm` oraz autoryzacji AAD/OIDC (bez kluczy w kodzie).

## Ostrzeżenie bezpieczeństwa
Wartość sekretu użyta w bloku `admin_password` zostanie zapisana w stanie Terraform. W środowiskach produkcyjnych preferuj:
- Klucze SSH (`admin_ssh_key`) dla Linux.
- Dostęp just-in-time / Azure AD logon / bastion.
- Sekret pobierany przez cloud-init z bezpiecznego źródła (lub Managed Identity) zamiast wpisywania hasła.

## Konfiguracja – pobranie sekretu
Używamy data source `azurerm_key_vault_secret` aby odczytać istniejący sekret:
```hcl
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = var.vm_password_secret_name
  key_vault_id = data.azurerm_key_vault.kv.id
}
```

## Tworzenie maszyny (Linux przykład)
```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.project}-${var.environment}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1ms"
  admin_username      = var.admin_username
  admin_password      = data.azurerm_key_vault_secret.vm_password.value

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

## Zmienne (fragment)
```hcl
variable "key_vault_name" { type = string }
variable "key_vault_rg" { type = string }
variable "vm_password_secret_name" { type = string default = "app-password" }
variable "admin_username" { type = string default = "azureuser" }
```

## Kroki
1. Dodaj powyższe bloki do `lab14/main.tf` (lub odpowiedniego katalogu labu).
2. Uzupełnij `terraform.tfvars` lub `dev.tfvars` danymi Key Vault: `key_vault_name`, `key_vault_rg`.
3. `terraform init`
4. `terraform plan` – zobacz użycie data sources oraz tworzenie VM.
5. `terraform apply` – utworzenie VM z hasłem z sekretu.
6. (Test) Zaloguj się przez SSH: `ssh azureuser@<public_ip>` (jeśli utworzono publiczny adres) – podaj hasło z sekretu (tylko w środowisku labowym).

## Weryfikacja
- VM utworzone i dostępne.
- Hasło = wartość sekretu z Key Vault.
- Brak outputu ujawniającego hasło.
- Data sources nie tworzą zasobów – tylko odczyt.

## Dobre praktyki
| Obszar | Rekomendacja |
|--------|--------------|
| Hasła | Unikaj – preferuj SSH keys lub Managed Identity |
| Sekrety w stanie | Ogranicz dostęp do backendu Terraform (RBAC + audit) |
| Rotacja | Rotuj sekret cyklicznie i wymuszaj redeploy / update VM |
| Dostęp sieciowy | Użyj NSG / brak public IP + Bastion w prod |
| Zmiana hasła | Aktualizacja sekretu → plan pokaże zmianę VM (może wymagać reprovision) |

## Alternatywy
- Cloud-init + pobranie sekretu runtime przez MSI i `az cli` bez przechowywania w stanie.
- Użycie `azurerm_windows_virtual_machine` z `admin_password` (analogicznie – te same ostrzeżenia).
- Integracja z Key Vault VM Extension (dla certyfikatów / sekretów plikowych).

## Typowe problemy
| Problem | Przyczyna | Rozwiązanie |
|---------|-----------|-------------|
| 403 przy odczycie sekretu | Brak uprawnień czytania KV (RBAC) | Dodaj rolę `Key Vault Secrets User` dla tożsamości Terraform |
| Plan pokazuje odtworzenie VM | Zmiana krytycznego parametru (hasło) | Akceptuj lub przejdź na SSH keys |
| Sekret nie istnieje | Błędna nazwa | Sprawdź w Portalu / `az keyvault secret list` |
| Hasło nie spełnia polityki | Zbyt słabe | Zmień sekret w KV na zgodny z wymaganiami Azure |

## Rozszerzenia
- Dodaj generowanie losowego hasła: `random_password` + zapis do Key Vault (uwaga: dalej w stanie).
- Dodaj Private Endpoint dla Key Vault i VM w sieci prywatnej.
- Dodaj monitoring VM (agent) i eksport logów do Log Analytics (lab 12 integration).

## Sprzątanie
`terraform destroy` (usunięcie VM). Key Vault i sekret możesz pozostawić do dalszych labów.

## Checklist końcowa
- [ ] Data sources Key Vault dodane
- [ ] VM utworzona z hasłem z sekretu
- [ ] Brak ujawnienia hasła w outputach
- [ ] Dostęp do stanu zabezpieczony (backend)
- [ ] Świadomość ryzyka przechowywania haseł w stanie

## Następny krok
Możesz rozszerzyć lab o rotację sekretu + odświeżenie maszyny lub migrację na SSH keys.
