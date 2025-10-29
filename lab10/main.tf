resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  base = lower("${var.project}-${var.environment}-${random_string.suffix.result}")
}

resource "azurerm_resource_group" "rg" {
  name     = coalesce(var.resource_group_name, "${local.base}-rg")
  location = var.location
  tags     = var.tags
}

resource "azurerm_key_vault" "kv" {
  name                       = replace("${local.base}-kv", "-", "")
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.kv_sku
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  public_network_access_enabled = true
  enable_rbac_authorization  = true
  tags                       = var.tags
}

data "azurerm_client_config" "current" {}

locals {
  role_name = "Key Vault Secrets Officer"
  # Scope for role assignment at vault level
  kv_scope  = azurerm_key_vault.kv.id
  assignee_object_id = coalesce(var.assignee_object_id, data.azurerm_client_config.current.object_id)
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = local.kv_scope
  role_definition_name = local.role_name
  principal_id         = local.assignee_object_id
}

output "key_vault_name" {
  description = "Name of the created Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  lower   = true
  numeric = true
  special = false
}

locals {
  base_name = lower("${var.project}-${var.environment}-${random_string.suffix.result}")
  sa_name   = lower(replace("${var.storage_account_prefix}${random_string.suffix.result}", "-", ""))
}

resource "azurerm_resource_group" "rg" {
  name     = coalesce(var.resource_group_name, "${local.base_name}-rg")
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.base_name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_cidr]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${local.base_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.base_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

# Storage Account + Blob Container
resource "azurerm_storage_account" "sa" {
  name                            = local.sa_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
}

resource "azurerm_storage_container" "container" {
  name                  = var.blob_container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# SAS token (czasowy) do montowania przez blobfuse2 - ograniczony do kontenera
data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only        = true
  start             = timestamp()
  expiry            = timeadd(timestamp(), "24h")

  resource_types { service = true; container = true; object = true }
  services       { blob = true; queue = false; table = false; file = false }
  permissions    { read = true; list = true }

  # Ograniczenie do kontenera
  canonicalized_resource = "/blob/${azurerm_storage_account.sa.name}/${azurerm_storage_container.container.name}"
}

# Linux VM z cloud-init montującym blob kontener (blobfuse2)
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${local.base_name}-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

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

  custom_data = base64encode(templatefile("${path.module}/scripts/cloud-init.yaml", {
    sa_name    = azurerm_storage_account.sa.name,
    container  = azurerm_storage_container.container.name,
    mount_dir  = var.mount_dir,
    sas        = data.azurerm_storage_account_sas.sas.sas
  }))

  tags = var.tags
}

# Outputy
output "vm_private_ip" {
  description = "Private IP of VM"
  value       = azurerm_network_interface.nic.private_ip_address
}

output "blob_container_name" {
  description = "Blob container name mounted on VM"
  value       = azurerm_storage_container.container.name
}

output "mount_dir" {
  description = "Mount directory inside VM"
  value       = var.mount_dir
}

output "sas_token" {
  description = "SAS token used for blobfuse2 (ważność 24h)"
  value       = data.azurerm_storage_account_sas.sas.sas
  sensitive   = true
}
