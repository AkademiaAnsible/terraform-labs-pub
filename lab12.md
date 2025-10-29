# Lab 12: Dynamic Blocks w Terraform

## Cel
Poznać i przećwiczyć użycie `dynamic` block do generowania opcjonalnych/n-wielokrotnych zagnieżdżonych sekcji w zasobach. Zrozumieć kiedy dynamic jest potrzebny, a kiedy lepiej użyć osobnych zasobów lub prostych wyrażeń.

## Czego się nauczysz
- Składnia `dynamic "nazwa" { for_each = ... content { ... } }`.
- Różnica między `for_each` na zasobach a dynamic wewnątrz jednego zasobu.
- Wzorzec „opcjonalny blok” sterowany pustą listą / mapą.
- Unikanie nadmiernego użycia dynamic (anti-patterny).

## Kiedy używać dynamic
Używaj, gdy: 
1. Zagnieżdżony blok może wystąpić wiele razy i jego liczba jest sterowana wejściem (lista/mapa obiektów).
2. Blok jest opcjonalny (0..N wystąpień) i bez niego zasób jest nadal poprawny.
3. Nie ma natywnego zasobu zastępczego dla tej konfiguracji (np. `service_endpoints` w `azurerm_subnet`).

Nie używaj, gdy:
- Możesz utworzyć osobny zasób z `for_each` (lepsza adresowalność stanu).
- Chcesz tylko warunkowo ustawić pojedynczy atrybut (wystarczy operator trójargumentowy / `coalesce`).
- Kod staje się trudniejszy do czytania niż statyczne bloki.

## Przykład 1: Opcjonalne service endpoints w Subnet
```hcl
variable "subnet_service_endpoints" {
  description = "Lista service endpoints do dodania do subnetu (opcjonalnie)"
  type        = list(string)
  default     = []
}

resource "azurerm_subnet" "app" {
  name                 = "app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]

  dynamic "service_endpoints" {
    for_each = var.subnet_service_endpoints
    content {
      service = service_endpoints.value
    }
  }
}
```
Gdy lista pusta → brak bloków. Gdy np. `subnet_service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]` → 2 zagnieżdżone bloki.

## Przykład 2: Dynamic ip_rules w Storage Account (network_rules)
```hcl
variable "allowed_ips" {
  description = "Dozwolone adresy IP dla Storage (opcjonalnie)"
  type        = list(string)
  default     = []
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.prefix}sa"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = length(var.allowed_ips) > 0 ? "Deny" : "Allow"

    dynamic "ip_rules" {
      for_each = var.allowed_ips
      content {
        ip = ip_rules.value
      }
    }
  }
}
```
Jeśli brak IP → brak reguł, default_action = Allow. Jeśli są IP → reguły generowane, default_action = Deny (tylko dopuszczone adresy).

## Przykład 3: NSG i dynamic security_rule
```hcl
variable "nsg_rules" {
  description = "Lista reguł NSG"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name = "allow_ssh"
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "22"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
  ]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
```

## Przykład 4: Warunkowy blok (lista obiektów) – rozszerzenia VM Extensions
```hcl
variable "vm_extensions" {
  type = list(object({
    name                 = string
    publisher            = string
    type                 = string
    type_handler_version = string
    settings_json        = string
  }))
  default = []
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1ms"
  admin_username      = "azureuser"
  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk { caching = "ReadWrite" storage_account_type = "Standard_LRS" }
  source_image_reference { publisher = "Canonical" offer = "0001-com-ubuntu-server-jammy" sku = "22_04-lts" version = "latest" }

  dynamic "extension" {
    for_each = var.vm_extensions
    content {
      name                       = extension.value.name
      publisher                  = extension.value.publisher
      type                       = extension.value.type
      type_handler_version       = extension.value.type_handler_version
      settings                   = jsondecode(extension.value.settings_json)
    }
  }
}
```

## Ćwiczenie
1. Dodaj do zmiennej `allowed_ips` jeden adres publiczny swojej maszyny lokalnej i sprawdź plan.
2. Dodaj drugą regułę w `nsg_rules` na port 80.
3. Dodaj jedną rozszerzoną definicję `vm_extensions` (np. `AADLoginForLinux`).
4. Usuń wszystkie wpisy w `subnet_service_endpoints` i zobacz, że plan usuwa bloki.

## Walidacja
- Puste listy → brak dynamicznych podbloków.
- Dodanie elementu → dokładnie jeden nowy blok w planie.
- Usunięcie elementu → tylko ten blok znika (brak rekreacji całego zasobu).

## Anti-patterny
| Sytuacja | Dlaczego źle | Lepsze rozwiązanie |
|----------|--------------|--------------------|
| Dynamic dla pojedynczego bloku zawsze obecnego | Zbędna złożoność | Statyczny blok |
| Dynamic generujący kilkaset elementów | Trudne diffy, ryzyko dryftu | Osobne zasoby z `for_each` |
| Zagnieżdżone dynamic w dynamic | Spada czytelność | Spłaszczenie modelu danych / moduł |

## Dobre praktyki
- Nazwy kluczy czytelne: `nsg_rules`, `allowed_ips`.
- Typy dokładne: `list(object({...}))` zamiast `any`.
- Domyślnie pusty zestaw → brak efektów ubocznych.
- Komentarze przy bardziej złożonych strukturach.

## Checklist końcowa
- [ ] Subnet bez endpointów przy pustej liście
- [ ] Storage Account z ip_rules po dodaniu IP
- [ ] NSG z co najmniej jedną regułą dynamiczną
- [ ] VM bez rozszerzeń przy pustej liście / z rozszerzeniem po dodaniu obiektu
- [ ] Plan pokazuje tylko przyrostowe zmiany

## Następny krok
Lab 13: Key Vault i bezpieczne przechowywanie sekretów – później możesz połączyć dynamic z parametryzacją polityk dostępu.

## Sprzątanie
`terraform destroy` jeśli to środowisko tymczasowe.
