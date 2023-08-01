module "network_security_group" {
  source = "github.com/danielkhen/network_security_group_module"

  name                   = "example-nsg"
  location               = "westeurope"
  resource_group_name    = azurerm_resource_group.example.name
  network_security_rules = local.network_security_rules # View variable documentation
  log_analytics_id       = azurerm_log_analytics_workspace.example.id
}