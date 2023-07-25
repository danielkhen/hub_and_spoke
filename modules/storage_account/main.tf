resource "azurerm_storage_account" "storage" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  account_kind                  = var.account_kind
  access_tier                   = var.access_tier
  enable_https_traffic_only     = var.enable_https_traffic_only
  public_network_access_enabled = var.public_network_access_enabled

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

module "storage_diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name                       = "storage-diagnostics"
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = var.log_analytics_id
}

locals {
  subresources_diagnostics_map = {
    for diagnostic in var.subresources_diagnostics : diagnostic.name => merge(diagnostic, {
      target_resource_id = "${azurerm_storage_account.storage.id}/${diagnostic.name}Services/default/"
    })
  }
}

module "subresources_diagnostics" {
  source   = "github.com/danielkhen/diagnostic_setting_module"
  for_each = local.subresources_diagnostics_map

  name                       = each.value.diagnostics_name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = var.log_analytics_id
}