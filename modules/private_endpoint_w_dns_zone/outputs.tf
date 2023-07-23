output "dns_name" {
  description = "The name of the private dns zone."
  value       = azurerm_private_dns_zone.dns_zone.name
}

output "dns_id" {
  description = "The id of the private dns zone."
  value       = azurerm_private_dns_zone.dns_zone.id
}

output "dns_object" {
  description = "The private dns zone object."
  value       = azurerm_private_dns_zone.dns_zone
}

output "pe_name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.pe.name
}

output "pe_id" {
  description = "The id of the private endpoint."
  value       = azurerm_private_endpoint.pe.id
}

output "pe_object" {
  description = "The object of the private endpoint."
  value       = azurerm_private_endpoint.pe
}