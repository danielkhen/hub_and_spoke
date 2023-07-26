locals {
  location            = "westeurope"
  resource_group_name = "dtf-route-table-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  rt_name = "rt"

  routes = [
    {
      name                   = "TestRouteIP"
      address_prefix         = "10.0.0.0/16"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.0.10"
    },
    {
      name           = "TestRouteInternet"
      address_prefix = "11.0.0.0/16"
      next_hop_type  = "Internet"
    }
  ]
}

module "route_table" {
  source = "../"

  name                = local.rt_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  routes              = local.routes
}