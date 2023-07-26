resource "azurerm_private_dns_resolver" "resolver" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_network_id  = var.virtual_network_id

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  ip_allocation_method = "Dynamic"
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound_endpoint" {
  name                    = var.inbound_endpoint_name
  location                = var.location
  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id

  ip_configurations {
    subnet_id                    = var.inbound_endpoint_subnet_id
    private_ip_allocation_method = local.ip_allocation_method
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

