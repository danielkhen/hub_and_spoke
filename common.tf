locals {
  prefix   = "dtf"
  location = "westeurope"
}

module "ipam" {
  source = "github.com/danielkhen/ip_address_management_module"
}

locals {
  activity_log_analytics_name           = "activity-monitor-log-workspace"
  activity_log_analytics_resource_group = "dor-hub-n-spoke"
}

data "azurerm_log_analytics_workspace" "activity" {
  name                = local.activity_log_analytics_name
  resource_group_name = local.activity_log_analytics_resource_group
}

locals {
  peering_use_hub_gateway_transit      = true
  peering_use_spokes_remote_gateway    = true
  peering_use_spokes_forwarded_traffic = true
}

module "hub_to_work_peerings" {
  source = "github.com/danielkhen/virtual_network_peerings_module"

  first_resource_group_name = azurerm_resource_group.hub.name
  first_vnet_name           = module.hub_virtual_network.name
  first_vnet_id             = module.hub_virtual_network.id

  second_resource_group_name = azurerm_resource_group.work.name
  second_vnet_name           = module.work_virtual_network.name
  second_vnet_id             = module.work_virtual_network.id

  first_gateway_transit    = local.peering_use_hub_gateway_transit
  second_remote_gateway    = local.peering_use_spokes_remote_gateway
  second_forwarded_traffic = local.peering_use_spokes_forwarded_traffic

  depends_on = [module.hub_vpn_gateway]
}

module "hub_to_monitor_peerings" {
  source = "github.com/danielkhen/virtual_network_peerings_module"

  first_resource_group_name = azurerm_resource_group.hub.name
  first_vnet_name           = module.hub_virtual_network.name
  first_vnet_id             = module.hub_virtual_network.id

  second_resource_group_name = azurerm_resource_group.monitor.name
  second_vnet_name           = module.monitor_virtual_network.name
  second_vnet_id             = module.monitor_virtual_network.id

  first_gateway_transit    = local.peering_use_hub_gateway_transit
  second_remote_gateway    = local.peering_use_spokes_remote_gateway
  second_forwarded_traffic = local.peering_use_spokes_forwarded_traffic

  depends_on = [module.hub_vpn_gateway]
}