# Lab Advanced 13: Logic App Standard z Private VNet Integration

terraform {
  required_version = ">= 1.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Subnet dla VNet Integration (Logic App)
resource "azurerm_subnet" "logic" {
  name                 = "subnet-logic"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_logic_prefix]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

# Subnet dla Private Endpoints
resource "azurerm_subnet" "pe" {
  name                 = "subnet-pe"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_pe_prefix]
}

# Subnet dla innych zasobów
resource "azurerm_subnet" "other" {
  name                 = "subnet-other"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_other_prefix]
}

# Storage Account (dla Logic App backend)
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  # Wyłącz publiczny dostęp gdy Private Endpoint aktywny
  public_network_access_enabled = !var.enable_private_endpoint

  network_rules {
    default_action = var.enable_private_endpoint ? "Deny" : "Allow"
    bypass         = ["AzureServices"]
  }

  tags = var.tags
}

# Storage Containers (wymagane przez Logic App)
resource "azurerm_storage_container" "workflows" {
  name                  = "workflows"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

# Private DNS Zone dla Blob Storage
resource "azurerm_private_dns_zone" "blob" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

# Link DNS Zone do VNet
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  count                 = var.enable_private_endpoint ? 1 : 0
  name                  = "blob-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.blob[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# Private DNS Zone dla File Storage
resource "azurerm_private_dns_zone" "file" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "file" {
  count                 = var.enable_private_endpoint ? 1 : 0
  name                  = "file-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.file[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# Private DNS Zone dla Queue Storage
resource "azurerm_private_dns_zone" "queue" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "queue" {
  count                 = var.enable_private_endpoint ? 1 : 0
  name                  = "queue-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.queue[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# Private DNS Zone dla Table Storage
resource "azurerm_private_dns_zone" "table" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "privatelink.table.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "table" {
  count                 = var.enable_private_endpoint ? 1 : 0
  name                  = "table-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.table[0].name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# Private Endpoint dla Blob
resource "azurerm_private_endpoint" "blob" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.storage_name}-pe-blob"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${var.storage_name}-psc-blob"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob[0].id]
  }

  tags = var.tags
}

# Private Endpoint dla File
resource "azurerm_private_endpoint" "file" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.storage_name}-pe-file"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${var.storage_name}-psc-file"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "file-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.file[0].id]
  }

  tags = var.tags
}

# Private Endpoint dla Queue
resource "azurerm_private_endpoint" "queue" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.storage_name}-pe-queue"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${var.storage_name}-psc-queue"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "queue-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.queue[0].id]
  }

  tags = var.tags
}

# Private Endpoint dla Table
resource "azurerm_private_endpoint" "table" {
  count               = var.enable_private_endpoint ? 1 : 0
  name                = "${var.storage_name}-pe-table"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "${var.storage_name}-psc-table"
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "table-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.table[0].id]
  }

  tags = var.tags
}

# App Service Plan dla Logic App Standard
resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

# Logic App Standard (Workflow)
resource "azurerm_logic_app_standard" "logic" {
  name                       = var.logic_app_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  version                    = "~4"

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"     = "node"
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "WEBSITE_CONTENTOVERVNET"      = var.enable_private_endpoint ? "1" : "0"
  }

  site_config {
    vnet_route_all_enabled = var.enable_vnet_integration
    ftps_state             = "Disabled"
    min_tls_version        = "1.2"
  }

  tags = var.tags
}

# VNet Integration
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  count          = var.enable_vnet_integration ? 1 : 0
  app_service_id = azurerm_logic_app_standard.logic.id
  subnet_id      = azurerm_subnet.logic.id
}
