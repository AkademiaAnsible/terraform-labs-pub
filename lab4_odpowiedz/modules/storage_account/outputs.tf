output "storage_account_id" {
    value = [ for each in azurerm_storage_account.sa : each.id ]
}