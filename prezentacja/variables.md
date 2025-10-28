# Typy i struktury danych w HCL (Terraform) – przykłady

## 1. `string`
Pojedynczy ciąg znaków.

**Deklaracja:**
```hcl
variable "env" {
  type        = string
  default     = "dev"
}
```

---

## 2. `number`
Liczba całkowita lub zmiennoprzecinkowa.

**Deklaracja:**
```hcl
variable "instance_count" {
  type    = number
  default = 2
}
```

---

## 3. `bool`
Wartość logiczna: `true` lub `false`.

**Deklaracja:**
```hcl
variable "enabled" {
  type    = bool
  default = true
}
```

---

## 4. `list(<type>)`
Uporządkowana lista wartości tego samego typu.

**Deklaracja:**
```hcl
variable "subnet_names" {
  type    = list(string)
  default = ["subnet1", "subnet2"]
}
```

---

## 5. `set(<type>)`
Zbiór unikalnych wartości tego samego typu (kolejność niegwarantowana).

**Deklaracja:**
```hcl
variable "regions" {
  type    = set(string)
  default = ["westeurope", "northeurope"]
}
```

---

## 6. `map(<type>)`
Mapa klucz-wartość, gdzie klucze są stringami.

**Deklaracja:**
```hcl
variable "tags" {
  type = map(string)
  default = {
    environment = "dev"
    owner       = "team"
  }
}
```

---

## 7. `object({ ... })`
Struktura z nazwanymi polami o określonych typach.

**Deklaracja:**
```hcl
variable "vm_config" {
  type = object({
    name     = string
    size     = string
    priority = string
  })
  default = {
    name     = "vm1"
    size     = "Standard_B1s"
    priority = "Regular"
  }
}
```

---

## 8. `tuple([ ... ])`
Lista o ustalonej liczbie elementów, każdy może mieć inny typ.

**Deklaracja:**
```hcl
variable "example_tuple" {
  type    = tuple([string, number, bool])
  default = ["abc", 42, true]
}
```

---

## 9. Typy zagnieżdżone
Można łączyć typy, np. lista obiektów:

**Deklaracja:**
```hcl
variable "disks" {
  type = list(object({
    name = string
    size = number
  }))
  default = [
    { name = "os"  , size = 32 },
    { name = "data", size = 128 }
  ]
}
```

---

## 10. `any`
Dowolny typ (niezalecane, jeśli można określić typ jawnie).

**Deklaracja:**
```hcl
variable "dynamic_value" {
  type = any
}
```

---

Każdy typ można wykorzystać w zmiennych, lokalnych wartościach (`locals`), outputach i parametrach modułów.
