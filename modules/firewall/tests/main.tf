locals {
  location            = "westeurope"
  resource_group_name = "dtf-firewall-test"
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
      name           = "AzureFirewallSubnet"
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
  firewall_name     = "firewall"
  firewall_sku_tier = "Standard"
  firewall_ip_name  = "fw-pip"
}

module "firewall" {
  source = "../"

  name                = local.firewall_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  sku_tier            = local.firewall_sku_tier
  public_ip_name      = local.firewall_ip_name
  subnet_id           = module.vnet.subnet_ids["AzureFirewallSubnet"]
}
