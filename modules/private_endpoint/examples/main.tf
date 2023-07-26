module "private_endpoint" {
  source = "github.com/danielkhen/private_endpoint_module"

  name                = "example-pe"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  resource_id         = azurerm_storage_account.example.id
  subnet_id           = azurerm_subnet.example.id
  subresource_name    = "blob"

  private_dns_enabled = true
  dns_name            = "privatelink.blob.core.windows.net"

  log_analytics_enabled = true
  log_analytics_id      = azurerm_log_analytics_workspace.example.id
}