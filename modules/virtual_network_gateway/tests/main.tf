locals {
  location            = "westeurope"
  resource_group_name = "dtf-virtual-network-gateway-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  vnet_name          = "vnet"
  vnet_address_space = ["10.0.0.0/16"]

  vnet_subnets = [
    {
      name           = "GatewaySubnet"
      address_prefix = "10.0.0.0/24"
    }
  ]
}

module "vnet" {
  source = "../../virtual_network"

  name                = local.vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  address_space       = local.vnet_address_space
  subnets             = local.vnet_subnets
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
  virtual_network_gateway_name       = "vng"
  virtual_network_gateway_ip         = "vng-ip"
  virtual_network_gateway_sku        = "VpnGw1"
  virtual_network_gateway_type       = "Vpn"
  virtual_network_gateway_generation = "Generation1"
}

module "virtual_network_gateway" {
  source = "../"

  name                = local.virtual_network_gateway_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  ip_name             = local.virtual_network_gateway_ip
  sku                 = local.virtual_network_gateway_sku
  type                = local.virtual_network_gateway_type
  generation          = local.virtual_network_gateway_generation
  subnet_id           = module.vnet.subnet_ids["GatewaySubnet"]
  log_analytics_id    = data.azurerm_log_analytics_workspace.activity.id

}