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
  log_analytics_name = "log-analytics"
}

module "log_analytics_workspace" {
  source = "../../log_analytics_workspace"

  name                = local.log_analytics_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
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
}

locals {
  diagnostic_setting_name = "storage-diagnostics"
}

module "diagnostic_setting" {
  source = "../"

  name                       = local.diagnostic_setting_name
  log_analytics_workspace_id = module.log_analytics_workspace.id
  target_resource_id         = module.storage_account.id
}