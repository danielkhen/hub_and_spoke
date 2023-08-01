output "name" {
  description = "The name of the virtual network gateway."
  value       = azurerm_virtual_network_gateway.vnet_gateway.name
}

output "id" {
  description = "The id of the virtual network gateway."
  value       = azurerm_virtual_network_gateway.vnet_gateway.id
}

output "object" {
  description = "The virtual network gateway object."
  value       = azurerm_virtual_network_gateway.vnet_gateway
}