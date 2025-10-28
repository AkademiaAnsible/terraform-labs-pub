# Podstawowe bloki Terraform – opis i przykłady (Azure)

## 1. `provider`
Blok konfiguruje dostawcę chmury lub innego API, z którym Terraform będzie pracował.

**Przykład (Azure):**
```hcl
provider "azurerm" {
  features {}
}
```

---

## 2. `resource`
Definiuje zasób, który ma zostać utworzony, zmodyfikowany lub usunięty przez Terraform.

**Przykład (Resource Group w Azure):**
```hcl
resource "azurerm_resource_group" "example" {
  name     = "my-rg"
  location = "West Europe"
}
```

---

## 3. `variable`
Deklaruje zmienną wejściową, którą można nadpisać przez tfvars, CLI lub zmienne środowiskowe.

**Przykład:**
```hcl
variable "location" {
  type        = string
  default     = "West Europe"
  description = "Region Azure dla zasobów."
}
```

---

## 4. `output`
Definiuje wartości wyjściowe, które Terraform pokaże po zakończeniu `apply`.

**Przykład:**
```hcl
output "resource_group_name" {
  value       = azurerm_resource_group.example.name
  description = "Nazwa utworzonej grupy zasobów."
}
```

---

## 5. `locals`
Pozwala zdefiniować lokalne zmienne i wyrażenia do wielokrotnego użycia.

**Przykład:**
```hcl
locals {
  tags = {
    environment = "dev"
    owner       = "team"
  }
}
```

---

## 6. `data`
Służy do odczytu istniejących zasobów (tylko do odczytu, nie tworzy nowych).

**Przykład (pobranie subskrypcji):**
```hcl
data "azurerm_subscription" "current" {}
```

---

## 7. `module`
Pozwala na użycie zewnętrznych lub własnych modułów (wzorców) Terraform.

**Przykład:**
```hcl
module "rg" {
  source   = "Azure/avm-res-resource-group/azurerm"
  version  = "~> 1.0"
  name     = "my-rg"
  location = var.location
}
```

---

## 8. `backend`
Konfiguruje miejsce przechowywania pliku stanu (np. Azure Storage).

**Przykład:**
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

---

## 9. `terraform`
Blok globalnej konfiguracji projektu: wersje, providery, backend.

**Przykład:**
```hcl
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}
```

---


---

# Bloki zagnieżdżone i meta-argumenty

## Bloki zagnieżdżone (nested blocks)
Niektóre bloki, np. `resource`, mogą zawierać w sobie inne bloki, które opisują szczegółowe elementy zasobu. Przykładem jest blok `network_interface` w maszynie wirtualnej:

```hcl
resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm1"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"

  network_interface {
    name    = "nic1"
    primary = true
  }
}
```

---

## provisioner
Blok wewnątrz `resource`, pozwala wykonać akcje po utworzeniu/zmianie zasobu (np. skrypt lokalny lub zdalny). Używać ostrożnie!

**Przykład:**
```hcl
resource "azurerm_virtual_machine" "example" {
  # ...
  provisioner "local-exec" {
    command = "echo VM created!"
  }
}
```

---

## lifecycle
Blok wewnątrz `resource`, pozwala sterować cyklem życia zasobu (np. zapobiec usunięciu, wymusić odtworzenie przy zmianie).

**Przykład:**
```hcl
resource "azurerm_storage_account" "example" {
  # ...
  lifecycle {
    prevent_destroy = true
    ignore_changes = [tags]
  }
}
```

---

## Meta-argumenty (nie są blokami, ale często mylone)

### depends_on
Wymusza kolejność tworzenia zasobów, gdy zależność nie jest oczywista z konfiguracji.

**Przykład:**
```hcl
resource "azurerm_virtual_machine" "example" {
  # ...
  depends_on = [azurerm_network_interface.example]
}
```

### count
Pozwala utworzyć wiele instancji zasobu na podstawie liczby.

**Przykład:**
```hcl
resource "azurerm_resource_group" "example" {
  count    = 3
  name     = "my-rg-${count.index}"
  location = "West Europe"
}
```

### for_each
Tworzy wiele instancji na podstawie mapy lub listy (lepsza kontrola niż count).

**Przykład:**
```hcl
resource "azurerm_resource_group" "example" {
  for_each = toset(["dev", "test", "prod"])
  name     = "my-rg-${each.key}"
  location = "West Europe"
}
```

### provider
Pozwala wskazać, którego providera użyć dla danego zasobu (np. przy wielu subskrypcjach/Azure).

**Przykład:**
```hcl
resource "azurerm_resource_group" "example" {
  provider = azurerm.secondary
  name     = "my-rg"
  location = "West Europe"
}
```

---

> **Uwaga:** Meta-argumenty (`depends_on`, `count`, `for_each`, `provider`) są argumentami, a nie blokami – umieszcza się je w ciele bloku zasobu lub modułu.

Każdy z tych elementów pozwala lepiej kontrolować sposób działania i zależności w infrastrukturze kodowanej w Terraform.
