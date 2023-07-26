module "virtual_network_peerings" {
  source = "../"

  vnet_name                  = azurerm_virtual_network.example_local.name
  vnet_id                    = azurerm_virtual_network.example_local.id
  resource_group_name        = azurerm_resource_group.example_local.name
  remote_vnet_name           = azurerm_virtual_network.example_remote.name
  remote_vnet_id             = azurerm_virtual_network.example_remote.id
  remote_resource_group_name = azurerm_resource_group.example_remote.name

  allow_forwarded_traffic = false
  use_local_gateway       = true # Use a gateway in the example local vnet.
}
