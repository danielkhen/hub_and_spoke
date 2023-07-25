resource "azurerm_private_dns_zone" "dns_zone" {
  count = var.private_dns_enabled ? 1 : 0

  name                = var.dns_name
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  vnet_links_map = { for link in var.vnet_links : link.name => link }
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each = var.private_dns_enabled ? local.vnet_links_map : {}

  name                  = each.value.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone[0].name
  virtual_network_id    = each.value.vnet_id

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_private_endpoint" "pe" {
  location                      = var.location
  name                          = var.pe_name
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.subnet_id
  custom_network_interface_name = var.nic_name

  private_service_connection {
    name                           = var.private_service_connection_name
    is_manual_connection           = false
    private_connection_resource_id = var.resource_id
    subresource_names              = [var.subresource_name]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_enabled ? [true] : []

    content {
      name                 = var.dns_prefix
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone[0].id]
    }
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

module "nic-diagnostics" {
  source = "../diagnostic_setting"

  name                       = var.nic-diagnostics-name
  target_resource_id         = azurerm_private_endpoint.pe.network_interface[0].id
  log_analytics_workspace_id = var.log_analytics_id
}