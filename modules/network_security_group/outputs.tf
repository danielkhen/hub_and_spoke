output "name" {
  description = "The name of the network security group."
  value       = azurerm_network_security_group.nsg.name
}

output "id" {
  description = "The id of the network security group."
  value       = azurerm_network_security_group.nsg.id
}

output "object" {
  description = "The network security group object."
  value       = azurerm_network_security_group.nsg
}