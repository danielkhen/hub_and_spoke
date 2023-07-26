module "virtual_network_gateway" {
  source = "github.com/danielkhen/"

  name                = "example-vng"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  default_ip_name     = "default-ip"
  sku                 = "VpnGw1"
  type                = "Vpn"
  generation          = "Generation1"
  subnet_id           = azurerm_subnet.example.id

  active_active = true # Active active requires a second public ip
  aa_ip_name    = "aa-ip"

  vpn_address_space = ["172.0.0.0/16"] # enables p2s and default auth (AAD) requires aad credentials
  aad_tenant        = local.aad_tenant #should be sensitive
  aad_audience      = local.aad_audience

  log_analytics_enabled = true
  log_analytics_id      = azurerm_log_analytics_workspace.example.id
}