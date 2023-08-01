locals {
  ip_allocation_method = "Static"
  sku_name             = "AZFW_VNet"
  ip_sku               = "Standard"
}

resource "azurerm_public_ip" "ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = local.ip_sku
  allocation_method   = local.ip_allocation_method

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_public_ip" "management_ip" {
  count = var.forced_tunneling ? 1 : 0

  name                = var.management_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = local.ip_allocation_method
  sku                 = local.ip_sku

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  default_ip_configuration_name    = "default"
  management_ip_configuration_name = "management"
}

resource "azurerm_firewall" "firewall" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name           = local.sku_name
  sku_tier           = var.sku_tier
  firewall_policy_id = var.policy_id

  ip_configuration { #TODO check about private firewalls
    name                 = local.default_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.ip.id
    subnet_id            = var.subnet_id
  }

  dynamic "management_ip_configuration" {
    for_each = var.forced_tunneling ? [true] : []

    content {
      name                 = local.management_ip_configuration_name
      public_ip_address_id = azurerm_public_ip.management_ip[0].id
      subnet_id            = var.management_subnet_id
    }
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  firewall_diagnostic_name      = "${azurerm_firewall.firewall.name}-diagnostic"
  ip_diagnostic_name            = azurerm_public_ip.ip.name
  management_ip_diagnostic_name = "${azurerm_public_ip.management_ip.name}-diagnostic"
}

module "firewall_diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name                       = local.firewall_diagnostic_name
  target_resource_id         = azurerm_firewall.firewall.id
  log_analytics_workspace_id = var.log_analytics_id
}

module "ip_diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name                       = local.ip_diagnostic_name
  target_resource_id         = azurerm_public_ip.ip.id
  log_analytics_workspace_id = var.log_analytics_id
}

module "management_ip_diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name                       = local.management_ip_diagnostic_name
  target_resource_id         = azurerm_public_ip.management_ip[0].id
  log_analytics_workspace_id = var.log_analytics_id
}