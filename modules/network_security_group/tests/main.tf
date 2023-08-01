locals {
  location            = "westeurope"
  resource_group_name = "dtf-network-security-group-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location
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
  nsg_name = "nsg"

  network_security_rules = [
    {
      name                       = "test"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 100
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
  ]
}

module "nsg" {
  source = "../"

  name                   = local.nsg_name
  location               = local.location
  resource_group_name    = azurerm_resource_group.test_rg.name
  network_security_rules = local.network_security_rules
  log_analytics_id       = data.azurerm_log_analytics_workspace.activity.id
}