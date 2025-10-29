# Lab14: VM with password from Key Vault secret

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Optionally fetch Key Vault by name if key_vault_id is not provided
data "azurerm_key_vault" "kv" {
  count               = var.key_vault_id == "" && var.key_vault_name != "" ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

# Data source to read secret from Key Vault
# (Key Vault and secret must exist, e.g. from lab13)
data "azurerm_key_vault_secret" "vm_password" {
  name         = var.secret_name
  key_vault_id = var.key_vault_id != "" ? var.key_vault_id : (length(data.azurerm_key_vault.kv) > 0 ? data.azurerm_key_vault.kv[0].id : "")
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project}-vnet"
  address_space       = ["10.14.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.project}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.14.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.project}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${var.project}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = data.azurerm_key_vault_secret.vm_password.value
  network_interface_ids = [azurerm_network_interface.nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  tags = var.tags
}

output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "ID of the VM"
}

output "vm_admin_password" {
  value       = data.azurerm_key_vault_secret.vm_password.value
  description = "Password used for VM admin (from Key Vault secret)"
  sensitive   = true
}
