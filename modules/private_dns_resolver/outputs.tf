output "name" {
  description = "The name of the private dns resolver."
  value       = azurerm_private_dns_resolver.resolver.name
}

output "id" {
  description = "The id of the private dns resolver."
  value       = azurerm_private_dns_resolver.resolver.id
}

output "object" {
  description = "The private dns resolver object."
  value       = azurerm_private_dns_resolver.resolver
}

output "inbound_endpoint_ip" {
  description = "The private ip address of the inbound endpoint of the private dns resolver."
  value       = azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint.ip_configurations[0].private_ip_address
}