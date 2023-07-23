output "dns_name" {
  description = "The name of the dns zone."
  value       = var.is_private ? azurerm_private_dns_zone.dns_zone[0].name : azurerm_dns_zone.dns_zone[0].name
}

output "dns_id" {
  description = "The id of the dns zone."
  value       = var.is_private ? azurerm_private_dns_zone.dns_zone[0].id : azurerm_dns_zone.dns_zone[0].id
}

output "dns_object" {
  description = "The dns zone object."
  value       = var.is_private ? azurerm_private_dns_zone.dns_zone[0] : azurerm_dns_zone.dns_zone[0]
}

output "record_name" {
  description = "The name of the dns record."
  value       = var.is_private ? azurerm_private_dns_a_record.record[0].name : azurerm_dns_a_record.record[0].name
}

output "record_id" {
  description = "The id of the dns record."
  value       = var.is_private ? azurerm_private_dns_a_record.record[0].id : azurerm_dns_a_record.record[0].id
}

output "record_object" {
  description = "The dns record object."
  value       = var.is_private ? azurerm_private_dns_a_record.record[0] : azurerm_dns_a_record.record[0]
}