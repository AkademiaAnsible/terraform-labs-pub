output "random_postfix" {
    value = random_string.suffix.result
}

output "rg_name" {
 value = azurerm_resource_group.rg.name 
}