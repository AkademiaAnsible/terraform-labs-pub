output "private_endpoint_ip_address" {
  description = "Prywatny adres IP przydzielony do Private Endpoint."
  value       = module.storage.private_endpoint_ip_address
}
