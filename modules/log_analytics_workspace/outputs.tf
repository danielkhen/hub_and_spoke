output "name" {
  description = "The name of the log analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.name
}

output "id" {
  description = "The id of the log analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "object" {
  description = "The log analytics workspace object"
  value       = azurerm_log_analytics_workspace.log_analytics
}