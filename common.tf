module "ipam" {
  source = "github.com/danielkhen/ip_address_management_module"
}

locals {
  prefix                        = "dtf"
  location                      = "westeurope"
  private_endpoints_enabled     = true
  private_endpoints_dns_enabled = true

  network_vars = {
    vnet_address_prefixes   = module.ipam.vnet_address_prefixes
    subnet_address_prefixes = module.ipam.subnet_address_prefixes
    private_ip_addresses    = module.ipam.private_ip_addresses

    vpn_address_prefixes = {
      full        = module.ipam.vpn_address_prefix
      first_half  = cidrsubnet(module.ipam.vpn_address_prefix, 1, 0)
      second_half = cidrsubnet(module.ipam.vpn_address_prefix, 1, 1)
    }
  }

  vm_size           = "Standard_B2s"
  vm_os_type        = "Linux"
  vm_admin_username = "daniel"
  vm_identity_type  = "SystemAssigned"

  vm_os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  vm_source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
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
  peering_use_local_gateway        = true
  peering_local_forwarded_traffic  = false
  peering_remote_forwarded_traffic = true
}

module "hub_to_work_peerings" {
  source = "./modules/virtual_network_peerings"

  resource_group_name = azurerm_resource_group.hub.name
  vnet_name           = module.hub_virtual_network.name
  vnet_id             = module.hub_virtual_network.id

  remote_resource_group_name = azurerm_resource_group.work.name
  remote_vnet_name           = module.work_virtual_network.name
  remote_vnet_id             = module.work_virtual_network.id

  use_local_gateway        = local.peering_use_local_gateway
  local_forwarded_traffic  = local.peering_local_forwarded_traffic
  remote_forwarded_traffic = local.peering_remote_forwarded_traffic

  depends_on = [module.hub_vpn_gateway]
}

module "hub_to_monitor_peerings" {
  source = "./modules/virtual_network_peerings"

  resource_group_name = azurerm_resource_group.hub.name
  vnet_name           = module.hub_virtual_network.name
  vnet_id             = module.hub_virtual_network.id

  remote_resource_group_name = azurerm_resource_group.monitor.name
  remote_vnet_name           = module.monitor_virtual_network.name
  remote_vnet_id             = module.monitor_virtual_network.id

  use_local_gateway        = local.peering_use_local_gateway
  local_forwarded_traffic  = local.peering_local_forwarded_traffic
  remote_forwarded_traffic = local.peering_remote_forwarded_traffic

  depends_on = [module.hub_vpn_gateway]
}