output "name" {
  description = "The name of the dns zone."
  value       = var.is_private ? azurerm_private_dns_zone.private_dns_zone[0].name : azurerm_dns_zone.dns_zone[0].name
}

output "id" {
  description = "The id of the dns zone."
  value       = var.is_private ? azurerm_private_dns_zone.private_dns_zone[0].id : azurerm_dns_zone.dns_zone[0].id
}

output "object" {
  description = "The dns zone object."
  value       = var.is_private ? azurerm_private_dns_zone.private_dns_zone[0] : azurerm_dns_zone.dns_zone[0]
}