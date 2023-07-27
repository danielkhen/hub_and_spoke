locals {
  ip_allocation_method = "Static"
  sku_name             = "AZFW_VNet"
  ip_sku               = "Standard"
}

resource "azurerm_public_ip" "fw_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = local.ip_sku
  allocation_method   = local.ip_allocation_method

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_public_ip" "fw_management_ip" {
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

resource "azurerm_firewall" "fw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name           = local.sku_name
  sku_tier           = var.sku_tier
  firewall_policy_id = var.policy_id

  ip_configuration {
    name                 = var.ip_configuration_name
    public_ip_address_id = azurerm_public_ip.fw_ip.id
    subnet_id            = var.subnet_id
  }

  dynamic "management_ip_configuration" {
    for_each = var.forced_tunneling ? [true] : []

    content {
      name                 = var.management_ip_configuration_name
      public_ip_address_id = azurerm_public_ip.fw_management_ip[0].id
      subnet_id            = var.management_subnet_id
    }
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

module "fw_diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"
  count  = var.log_analytics_enabled ? 1 : 0

  name                       = var.fw_diagnostics_name
  target_resource_id         = azurerm_firewall.fw.id
  log_analytics_workspace_id = var.log_analytics_id
}

module "fw_ip_diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"
  count  = var.log_analytics_enabled ? 1 : 0

  name                       = var.pip_diagnostics_name
  target_resource_id         = azurerm_public_ip.fw_ip.id
  log_analytics_workspace_id = var.log_analytics_id
}

module "fw_management_ip_diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"
  count  = var.log_analytics_enabled && var.forced_tunneling ? 1 : 0

  name                       = var.management_pip_diagnostics_name
  target_resource_id         = azurerm_public_ip.fw_management_ip[0].id
  log_analytics_workspace_id = var.log_analytics_id
}