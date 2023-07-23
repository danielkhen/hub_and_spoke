resource "azurerm_virtual_network_peering" "outgoing_peering" {
  name                      = "${var.vnet_name}-to-${var.remote_vnet_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.vnet_name
  remote_virtual_network_id = var.remote_vnet_id


  allow_forwarded_traffic = var.allow_forwarded_traffic
  allow_gateway_transit   = var.use_local_gateway
  use_remote_gateways     = false
}

resource "azurerm_virtual_network_peering" "ingoing_peering" {
  name                      = "${var.remote_vnet_name}-to-${var.vnet_name}"
  resource_group_name       = var.remote_resource_group_name
  virtual_network_name      = var.remote_vnet_name
  remote_virtual_network_id = var.vnet_id

  allow_forwarded_traffic = var.allow_forwarded_traffic
  allow_gateway_transit   = false
  use_remote_gateways     = var.use_local_gateway
}