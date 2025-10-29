resource "random_string" "suffix" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}

# Resource Group: create if not provided and not importing
resource "azurerm_resource_group" "rg" {
  count    = var.resource_group_name == "" && var.import_existing_rg_name == "" ? 1 : 0
  name     = "${local.name_suffix}-${random_string.suffix.result}-rg"
  location = var.location
  tags     = local.tags
}

data "azurerm_resource_group" "existing" {
  count = var.import_existing_rg_name != "" ? 1 : 0
  name  = var.import_existing_rg_name
}

# Network Security Group with dynamic rules
resource "azurerm_network_security_group" "nsg" {
  name                = "${local.name_suffix}-${random_string.suffix.result}-nsg"
  location            = var.location
  resource_group_name = coalesce(try(azurerm_resource_group.rg[0].name, null), try(data.azurerm_resource_group.existing[0].name, null), local.rg_name_effective)
  tags                = local.tags

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = try(security_rule.value.source_port_range, null)
      destination_port_range       = try(security_rule.value.destination_port_range, null)
      source_port_ranges           = try(security_rule.value.source_port_ranges, null)
      destination_port_ranges      = try(security_rule.value.destination_port_ranges, null)
      source_address_prefix        = try(security_rule.value.source_address_prefix, null)
      source_address_prefixes      = try(security_rule.value.source_address_prefixes, null)
      destination_address_prefix   = try(security_rule.value.destination_address_prefix, null)
      destination_address_prefixes = try(security_rule.value.destination_address_prefixes, null)
    }
  }
}
