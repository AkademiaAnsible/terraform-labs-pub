output "functionapp_id" {
  value       = azurerm_linux_function_app.this.id
  description = "ID utworzonej Function App"
}

output "functionapp_name" {
  value       = azurerm_linux_function_app.this.name
  description = "Nazwa utworzonej Function App"
}

output "function_app_default_hostname" {
  value       = azurerm_linux_function_app.this.default_hostname
  description = "Domyślny hostname Function App"
}
