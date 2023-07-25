output "name" {
  description = "The name of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.diagnostics.name
}

output "id" {
  description = "The id of the diagnostic setting."
  value       = azurerm_monitor_diagnostic_setting.diagnostics.id
}

output "object" {
  description = "The diagnostic setting object."
  value       = azurerm_monitor_diagnostic_setting.diagnostics
}