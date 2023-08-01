resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = var.sku
  internet_ingestion_enabled = var.internet_ingestion_enabled
  internet_query_enabled     = var.internet_query_enabled


  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  diagnostic_name = "${azurerm_log_analytics_workspace.log_analytics.name}-diagnostic"
}

module "log_analytics_diagnostic" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name                       = local.diagnostic_name
  target_resource_id         = azurerm_log_analytics_workspace.log_analytics.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id
}