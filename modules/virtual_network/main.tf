resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  subnets_map                        = { for subnet in var.subnets : subnet.name => subnet }
  subnets_network_security_group_map = { for subnet in var.subnets : subnet.name => subnet if subnet.network_security_group_association }
  subnets_route_tables_map           = { for subnet in var.subnets : subnet.name => subnet if subnet.route_table_association }
}

locals {
  dns_resolver_service_delegation_name    = "Microsoft.Network/dnsResolvers"
  dns_resolver_service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
}

resource "azurerm_subnet" "subnets" {
  for_each = local.subnets_map

  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes

}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = local.subnets_network_security_group_map

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  for_each = local.subnets_route_tables_map

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = each.value.route_table_id
}