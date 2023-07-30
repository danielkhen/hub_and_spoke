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
  subnet_deployment_mode             = "Incrementaly"
  subnet_template_content            = file("./subnet_template.json")
}

#resource "azurerm_resource_group_template_deployment" "subnets" {
#  for_each = local.subnets_map
#
#  name                = "${each.value.name}-template"
#  resource_group_name = var.resource_group_name
#  deployment_mode     = local.subnet_deployment_mode
#
#  template_content = local.subnet_template_content
#
#  parameters_content = jsonencode({
#    vnet_name = {
#      value = azurerm_virtual_network.vnet.name
#    }
#    subnet_name = {
#      value = each.value.name
#    }
#    subnet_address_prefix = {
#      value = each.value.address_prefix
#    }
#    network_security_group_id = {
#      value = each.value.network_security_group_id
#    }
#    route_table_id = {
#      value = each.value.route_table_id
#    }
#  })
#}

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