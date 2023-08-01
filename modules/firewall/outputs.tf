output "name" {
  description = "The name of the firewall."
  value       = azurerm_firewall.firewall.name
}

output "id" {
  description = "The id of the firewall."
  value       = azurerm_firewall.firewall.id
}

output "object" {
  description = "The firewall object."
  value       = azurerm_firewall.firewall
}