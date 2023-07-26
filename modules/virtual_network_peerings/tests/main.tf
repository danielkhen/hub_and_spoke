locals {
  location            = "westeurope"
  resource_group_name = "dtf-virtual-network-peerings-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  local_vnet_name          = "local-vnet"
  local_vnet_address_space = ["10.0.0.0/16"]
}

module "local_vnet" {
  source = "../../virtual_network"

  name                = local.local_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  address_space       = local.local_vnet_address_space
  subnets             = []
}

locals {
  remote_vnet_name          = "remote-vnet"
  remote_vnet_address_space = ["10.1.0.0/16"]
}

module "remote_vnet" {
  source = "../../virtual_network"

  name                = local.remote_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  address_space       = local.remote_vnet_address_space
  subnets             = []
}

module "virtual_network_peerings" {
  source = "../"

  vnet_name                  = module.local_vnet.name
  vnet_id                    = module.local_vnet.id
  resource_group_name        = azurerm_resource_group.test_rg.name
  remote_vnet_name           = module.remote_vnet.name
  remote_vnet_id             = module.remote_vnet.id
  remote_resource_group_name = azurerm_resource_group.test_rg.name
}