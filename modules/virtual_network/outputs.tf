output "name" {
  description = "The name of the virtual network."
  value       = azurerm_virtual_network.vnet.name
}

output "id" {
  description = "The id of the virtual network."
  value       = azurerm_virtual_network.vnet.id
}

output "object" {
  description = "The virtual network object."
  value       = azurerm_virtual_network.vnet
}

output "subnet_ids" {
  description = "A map for subnet name to id."
  value       = { for subnet in azurerm_subnet.subnets : subnet.name => subnet.id }
}

output "subnet_address_prefixes" {
  description = "A map for subnet name to address prefix."
  value       = { for subnet in azurerm_subnet.subnets : subnet.name => subnet.address_prefix }
}