module "firewall" {
  source = "github.com/danielkhen/firewall_module"

  name                = "example-firewall"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  policy_id           = azurerm_firewall_policy.example.id
  public_ip_name      = "example-public-ip"
  sku_tier            = "Standard"
  subnet_id           = azurerm_subnet.firewall_example.id

  forced_tunneling          = true # Forced tunneling requires another public ip
  management_public_ip_name = "example-management-public-ip"
  management_subnet_id      = azurerm_subnet.firewall_management_example.id
  log_analytics_id          = azurerm_log_analytics_workspace.example.id
}