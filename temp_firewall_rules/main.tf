locals {
  firewall_policy_name           = "dtf-hub-fw-policy"
  firewall_policy_resource_group = "dtf-hub"
}

data "azurerm_firewall_policy" "policy" {
  name                = local.firewall_policy_name
  resource_group_name = local.firewall_policy_resource_group
}