module "diagnostic_setting" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name = "example-name"
  # Use either log analytics workspace or storage account or both to send logs to.
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  storage_account_id         = azurerm_storage_account.example.id
  target_resource_id         = azurerm_network_interface.example.id
}