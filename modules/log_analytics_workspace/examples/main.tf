module "log_analytics_workspace" {
  source = "github.com/danielkhen/log_analytics_workspace_module"

  name                       = "example-log-analytics"
  location                   = "westeurope"
  resource_group_name        = azurerm_resource_group.example.name
  internet_ingestion_enabled = true
  internet_query_enabled     = true
  sku                        = "Free"
  log_analytics_enabled      = true
}