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
  value       = { for subnet in var.subnets : subnet.name => jsondecode(azurerm_resource_group_template_deployment.subnets[subnet.name].output_content).subnet_id }
}