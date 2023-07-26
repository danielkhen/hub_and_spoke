locals {
  location            = "westeurope"
  resource_group_name = "dtf-log-analytics-workspace-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  log_analytics_workspace_name = "log-analytics-workspace"
}

module "log_analyitics_workspace" {
  source = "../"

  name                = local.log_analytics_workspace_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
}