module "storage_account" {
  source = "github.com/danielkhen/storage_account_module"

  name                          = "example-storage"
  location                      = "westeurope"
  resource_group_name           = azurerm_resource_group.example.name
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "BlobStorage"
  enable_https_traffic_only     = true
  access_tier                   = "Hot"
  public_network_access_enabled = false
  log_analytics_id              = azurerm_log_analytics_workspace.example.id
}