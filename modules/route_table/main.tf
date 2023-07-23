resource "azurerm_route_table" "rt" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  routes_map = { for route in var.routes : route.name => route }
}

resource "azurerm_route" "routes" {
  for_each = local.routes_map

  name                = each.value.name
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.rt.name

  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}