output "name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.pe.name
}

output "id" {
  description = "The id of the private endpoint."
  value       = azurerm_private_endpoint.pe.id
}

output "object" {
  description = "The object of the private endpoint."
  value       = azurerm_private_endpoint.pe
}