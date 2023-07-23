output "name" {
  description = "The name of the diagnostic setting."
  value       = try(azurerm_monitor_diagnostic_setting.diagnostics[0].name, null)
}

output "id" {
  description = "The id of the diagnostic setting."
  value       = try(azurerm_monitor_diagnostic_setting.diagnostics[0].id, null)
}

output "object" {
  description = "The diagnostic setting object."
  value       = try(azurerm_monitor_diagnostic_setting.diagnostics[0], null)
}