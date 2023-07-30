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
  subnet_deployment_mode             = "Incremental"
  subnet_template_content            = file("${path.module}/subnet_template.json")
}

resource "azurerm_resource_group_template_deployment" "subnets" {
  for_each = local.subnets_map

  name                = "${each.value.name}-template"
  resource_group_name = var.resource_group_name
  deployment_mode     = local.subnet_deployment_mode

  template_content = local.subnet_template_content

  parameters_content = jsonencode({
    vnet_name = {
      value = azurerm_virtual_network.vnet.name
    }
    subnet_name = {
      value = each.value.name
    }
    subnet_address_prefix = {
      value = each.value.address_prefix
    }
    network_security_group_id = {
      value = each.value.network_security_group_id
    }
    route_table_id = {
      value = each.value.route_table_id
    }
  })
}