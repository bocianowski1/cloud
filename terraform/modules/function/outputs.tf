output "function_name" {
  value       = azurerm_function_app.function.name
  description = "Deployed function name"
}

output "function_default_hostname" {
  value       = azurerm_function_app.function.default_hostname
  description = "Deployed function default hostname"
}