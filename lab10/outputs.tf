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
