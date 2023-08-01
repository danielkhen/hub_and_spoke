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

locals {
  storage_account_diagnostic_name = "${azurerm_storage_account.storage.name}-diagnostic"
}

module "storage_diagnostic" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name                       = local.storage_account_diagnostic_name
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = var.log_analytics_id
}

locals {
  subresources = ["blob", "file", "table", "queue"]
  subresources_diagnostic_map = {
    for subresource in local.subresources : subresource => {
      name               = "${azurerm_storage_account.storage.name}-${subresource}-diagnostic"
      target_resource_id = "${azurerm_storage_account.storage.id}/${subresource}Services/default/"
    }
  }
}

module "subresources_diagnostics" {
  source   = "github.com/danielkhen/diagnostic_setting_module"
  for_each = local.subresources_diagnostic_map

  name                       = each.value.name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = var.log_analytics_id
}