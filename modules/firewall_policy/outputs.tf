output "name" {
  description = "The name of the firewall policy."
  value       = azurerm_firewall_policy.policy.name
}

output "id" {
  description = "The id of the firewall policy."
  value       = azurerm_firewall_policy.policy.id
}

output "object" {
  description = "The firewall policy object."
  value       = azurerm_firewall_policy.policy
}