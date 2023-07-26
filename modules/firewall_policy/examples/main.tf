module "firewall_policy" {
  source = "github.com/danielkhen/firewall_policy_module"

  name                = "example-firewall-policy"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name

  # View variable documentation
  network_rule_collection_groups     = local.network_rule_collection_groups
  application_rule_collection_groups = local.application_rule_collection_groups
  nat_rule_collection_groups         = local.nat_rule_collection_groups

  dns_proxy_enabled = true
  dns_servers       = ["10.0.0.10"]
}