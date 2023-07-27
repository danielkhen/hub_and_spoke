locals {
  prefix                        = "dtf"
  location                      = "westeurope"
  log_analytics_enabled         = true
  private_endpoints_dns_enabled = true

  network_vars = {
    ip_addresses = {
      firewall = cidrhost(local.hub_vnet_subnets_map.AzureFirewallSubnet.address_prefix, 4)
    }

    address_prefixes = {
      hub_vnet     = local.hub_vnet_address_space[0]
      work_vnet    = local.work_vnet_address_space[0]
      monitor_vnet = local.monitor_vnet_address_space[0]
      vpn          = local.hub_vng_vpn_address_space[0]
      vpn_pool_1   = cidrsubnet(local.hub_vng_vpn_address_space[0], 1, 0)
      vpn_pool_2   = cidrsubnet(local.hub_vng_vpn_address_space[0], 1, 1)
    }

    subnets = {
      hub     = { for name, subnet in local.hub_vnet_subnets_map : name => subnet.address_prefix }
      work    = { for name, subnet in local.work_vnet_subnets_map : name => subnet.address_prefix }
      monitor = { for name, subnet in local.monitor_vnet_subnets_map : name => subnet.address_prefix }
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
  peering_use_local_gateway = true
}

module "hub_to_work_peerings" {
  source = "./modules/virtual_network_peerings"

  resource_group_name = azurerm_resource_group.hub.name
  vnet_name           = module.hub_virtual_network.name
  vnet_id             = module.hub_virtual_network.id

  remote_resource_group_name = azurerm_resource_group.work.name
  remote_vnet_name           = module.work_virtual_network.name
  remote_vnet_id             = module.work_virtual_network.id
  use_local_gateway          = local.peering_use_local_gateway

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
  use_local_gateway          = local.peering_use_local_gateway

  depends_on = [module.hub_vpn_gateway]
}