output "resource_group_name" {
  description = "Effective resource group name used"
  value       = coalesce(try(azurerm_resource_group.rg[0].name, null), try(data.azurerm_resource_group.existing[0].name, null), local.rg_name_effective)
}

output "nsg_id" {
  description = "NSG id"
  value       = azurerm_network_security_group.nsg.id
}
