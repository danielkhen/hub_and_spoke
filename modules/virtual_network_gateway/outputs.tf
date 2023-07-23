output "name" {
  description = "The name of the virtual network gateway."
  value       = azurerm_virtual_network_gateway.vng.name
}

output "id" {
  description = "The id of the virtual network gateway."
  value       = azurerm_virtual_network_gateway.vng.id
}

output "object" {
  description = "The virtual network gateway object."
  value       = azurerm_virtual_network_gateway.vng
}