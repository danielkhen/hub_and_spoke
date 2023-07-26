output "monitor_dns_resolver_ip" {
  description = "The private ip address of the inbound endpoint of the private dns resolver in the monitor virtual network."
  value       = module.monitor_private_dns_resolver.inbound_endpoint_ip
}