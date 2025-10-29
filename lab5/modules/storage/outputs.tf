output "private_endpoint_ip_address" {
  description = "Prywatny adres IP przydzielony do Private Endpoint."
  value       = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
  sensitive   = true
}

output "private_dns_zone_name" {
  description = "Nazwa strefy Private DNS wykorzystywanej przez Private Endpoint."
  value       = azurerm_private_dns_zone.pdz.name
}
