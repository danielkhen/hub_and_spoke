locals {
  location            = "westeurope"
  resource_group_name = "dtf-firewall-policy-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  firewall_policy_name = "firewall-policy"

  network_rule_collection_groups = [
    {
      name     = "test-network-group"
      priority = 100
      rule_collections = [
        {
          name     = "test-collection"
          action   = "Allow"
          priority = 100
          rules = [
            {
              name                  = "test-rule"
              source_addresses      = ["*"]
              protocols             = ["Any"]
              destination_ports     = ["*"]
              destination_addresses = ["*"]
            }
          ]
        }
      ]
    }
  ]

  application_rule_collection_groups = [
    {
      name     = "test-network-group"
      priority = 100
      rule_collections = [
        {
          name     = "test-collection"
          action   = "Allow"
          priority = 200
          rules = [
            {
              name              = "test-rule"
              source_addresses  = ["*"]
              destination_fqdns = ["*"]
              protocols = [
                {
                  type = "Https"
                  port = 443
                }
              ]
            }
          ]
        }
      ]
    }
  ]

  nat_rule_collection_groups = [
    {
      name     = "test-network-group"
      priority = 300
      rule_collections = [
        {
          name     = "test-collection"
          action   = "Dnat"
          priority = 100
          rules = [
            {
              name                = "test-rule"
              source_addresses    = ["*"]
              protocols           = ["TCP"]
              destination_ports   = [443]
              destination_address = "10.0.0.0"
              translated_address  = "10.0.0.1"
              translated_port     = 443
            }
          ]
        }
      ]
    }
  ]
}

module "firewall_policy" {
  source = "../"

  name                = local.firewall_policy_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name

  network_rule_collection_groups     = local.network_rule_collection_groups
  application_rule_collection_groups = local.application_rule_collection_groups
  nat_rule_collection_groups         = local.nat_rule_collection_groups
}