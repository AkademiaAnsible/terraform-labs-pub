# Terraform – Provisionery

Provisionery to mechanizmy pozwalające na wykonywanie dodatkowych akcji na maszynach wirtualnych lub lokalnie podczas tworzenia lub usuwania zasobów. Stosuje się je do inicjalizacji, kopiowania plików, uruchamiania skryptów itp. Zaleca się jednak ograniczanie ich użycia do przypadków, gdy nie da się osiągnąć celu natywnymi mechanizmami chmury lub providerów.

---

## local-exec

Provisioner uruchamiający polecenie lub skrypt na maszynie, na której działa Terraform (zwykle lokalnie na komputerze użytkownika lub w CI/CD).

**Przykład:**
```hcl
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello from local-exec > hello.txt"
  }
}
```

---

## remote-exec

Provisioner pozwalający na wykonanie poleceń na zdalnej maszynie (np. nowo utworzonej VM) przez SSH lub WinRM. Wymaga skonfigurowania połączenia.

**Przykład:**
```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  # ...
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
  connection {
    type     = "ssh"
    host     = self.public_ip_address
    user     = "azureuser"
    private_key = file(var.ssh_private_key)
  }
}
```

---

## file

Provisioner służący do kopiowania plików z maszyny lokalnej na zdalną (np. do nowo utworzonej VM). Wymaga sekcji `connection`.

**Przykład:**
```hcl
resource "azurerm_linux_virtual_machine" "vm" {
  # ...
  provisioner "file" {
    source      = "./app.conf"
    destination = "/tmp/app.conf"
  }
  connection {
    type     = "ssh"
    host     = self.public_ip_address
    user     = "azureuser"
    private_key = file(var.ssh_private_key)
  }
}
```

---

## Dobre praktyki i ograniczenia

- Provisionery powinny być używane tylko wtedy, gdy nie ma natywnego wsparcia w providerze lub module.
- Nie są idempotentne – mogą powodować nieprzewidywalne efekty przy ponownym uruchomieniu `apply`.
- Nie nadają się do zarządzania konfiguracją na dużą skalę (lepiej użyć narzędzi typu Ansible, Chef, cloud-init).
- Błędy w provisionerach mogą zatrzymać cały proces `apply`.
- W środowiskach produkcyjnych preferuj cloud-init, skrypty custom data lub dedykowane narzędzia konfiguracyjne.

---

Provisionery są narzędziem ostatniej szansy – korzystaj z nich świadomie i tylko tam, gdzie to konieczne.
