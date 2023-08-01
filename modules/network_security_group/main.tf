resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  network_security_rules_map = { for rule in var.network_security_rules : rule.name => rule }
}

resource "azurerm_network_security_rule" "rules" {
  for_each = local.network_security_rules_map

  name                        = each.value.name
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name

  access                     = each.value.access
  direction                  = each.value.direction
  priority                   = each.value.priority
  protocol                   = each.value.protocol
  source_address_prefix      = each.value.source_address_prefix
  source_port_range          = each.value.source_port_range
  destination_address_prefix = each.value.destination_address_prefix
  destination_port_range     = each.value.destination_port_range
}

locals {
  nsg_diagnostic_name = "${azurerm_network_security_group.nsg.name}-diagnostic"
}

module "nsg_diagnostic" {
  source                     = "github.com/danielkhen/diagnostic_setting_module"
  name                       = local.nsg_diagnostic_name
  target_resource_id         = azurerm_network_security_group.nsg.id
  log_analytics_workspace_id = var.log_analytics_id
}