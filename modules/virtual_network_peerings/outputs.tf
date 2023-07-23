output "outgoing_name" {
  description = "The name of the peering from the local to the remote virtual network."
  value       = azurerm_virtual_network_peering.outgoing_peering.name
}

output "outgoing_id" {
  description = "The id of the peering from the local to the remote virtual network."
  value       = azurerm_virtual_network_peering.outgoing_peering.id
}

output "outgoing_object" {
  description = "The peering from the local to the remote virtual network object."
  value       = azurerm_virtual_network_peering.outgoing_peering
}

output "ingoing_name" {
  description = "The name of the peering from the remote to the local virtual network."
  value       = azurerm_virtual_network_peering.ingoing_peering.name
}

output "ingoing_id" {
  description = "The id of the peering from the remote to the local virtual network."
  value       = azurerm_virtual_network_peering.ingoing_peering.id
}

output "ingoing_object" {
  description = "The peering from the remote to the local virtual network object."
  value       = azurerm_virtual_network_peering.ingoing_peering
}