locals {
  location            = "westeurope"
  resource_group_name = "dtf-diagnostic-setting-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
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
  storage_account_name             = "dtfdiagnosticsettingtest"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
}

module "storage_account" {
  source = "../../storage_account"

  name                     = local.storage_account_name
  location                 = local.location
  resource_group_name      = azurerm_resource_group.test_rg.name
  account_tier             = local.storage_account_tier
  account_replication_type = local.storage_account_replication_type
  log_analytics_id         = data.azurerm_log_analytics_workspace.activity.id
}

locals {
  diagnostic_setting_name = "storage-diagnostics"
}

module "diagnostic_setting" {
  source = "../"

  name                       = local.diagnostic_setting_name
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.activity.id
  target_resource_id         = module.storage_account.id
}