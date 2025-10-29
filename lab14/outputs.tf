output "vm_id" {
  value       = azurerm_linux_virtual_machine.vm.id
  description = "ID of the VM"
}

output "vm_admin_password" {
  value       = data.azurerm_key_vault_secret.vm_password.value
  description = "Password used for VM admin (from Key Vault secret)"
  sensitive   = true
}
