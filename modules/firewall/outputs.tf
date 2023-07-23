output "name" {
  description = "The name of the firewall."
  value       = azurerm_firewall.fw.name
}

output "id" {
  description = "The id of the firewall."
  value       = azurerm_firewall.fw.id
}

output "object" {
  description = "The firewall object."
  value       = azurerm_firewall.fw
}