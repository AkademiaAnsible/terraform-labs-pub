# Terraform – Meta-argumenty

Poniżej znajdziesz opisy oraz przykłady użycia najważniejszych meta-argumentów w Terraform.

---

## depends_on

Meta-argument wymuszający zależność między zasobami, nawet jeśli nie wynika ona z referencji w atrybutach. Używany, gdy chcemy mieć pewność, że dany zasób zostanie utworzony lub zaktualizowany po innym, np. przy zależnościach pośrednich lub działaniach poza HCL.

**Przykład:**
```hcl
resource "azurerm_network_interface" "nic" {
  # ...
}

resource "azurerm_virtual_machine" "vm" {
  # ...
  depends_on = [azurerm_network_interface.nic]
}
```

---

## count

Meta-argument pozwalający na tworzenie wielu instancji tego samego zasobu na podstawie liczby całkowitej. Indeks każdej instancji dostępny jest przez `count.index`. Użyteczny do prostych powtórzeń.

**Przykład:**
```hcl
resource "azurerm_network_interface" "nic" {
  count = 3
  name = "nic-${count.index}"
  # ...
}
```

---

## for_each

Meta-argument umożliwiający iterację po mapie lub zbiorze, zapewniając stabilne adresy zasobów (kluczowe przy usuwaniu/zmianach). Każda instancja dostępna jest przez `each.key` i `each.value`.

**Przykład:**
```hcl
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets
  name     = each.value.name
  address_prefix = each.value.prefix
  # ...
}
```

---

## provider

Meta-argument pozwalający wskazać, z którego providera (np. aliasowanego) ma korzystać dany zasób lub moduł. Przydatny przy pracy z wieloma subskrypcjami, regionami lub kontami.

**Przykład:**
```hcl
provider "azurerm" {
  alias           = "west"
  features        = {}
  subscription_id = "..."
  location        = "westeurope"
}

resource "azurerm_resource_group" "rg" {
  provider = azurerm.west
  name     = "rg-west"
  location = "westeurope"
}
```

---

## providers

Meta-argument stosowany w module, aby przekazać różne aliasy providerów do różnych zasobów wewnątrz modułu. Pozwala na elastyczne zarządzanie providerami w złożonych wdrożeniach.

**Przykład:**
```hcl
module "storage" {
  source = "./modules/storage"
  providers = {
    azurerm = azurerm.west
    random  = random
  }
  # ...
}
```

---

## lifecycle

Blok meta-argumentów pozwalający kontrolować zachowanie cyklu życia zasobu, np. ignorowanie zmian, wymuszanie utworzenia przed usunięciem, czy zapobieganie usunięciu.

**Przykład:**
```hcl
resource "azurerm_storage_account" "sa" {
  # ...
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
    create_before_destroy = true
  }
}
```

---

Każdy z tych meta-argumentów pozwala lepiej kontrolować i optymalizować zarządzanie infrastrukturą w Terraform.
