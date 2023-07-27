resource "azurerm_firewall_policy" "policy" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "dns" {
    for_each = var.dns_proxy_enabled ? [true] : []

    content {
      proxy_enabled = var.dns_proxy_enabled
      servers       = var.dns_servers
    }
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  network_rule_collection_groups_map = {
    for rule_collection_group in var.network_rule_collection_groups : rule_collection_group.name => rule_collection_group
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "network_rule_collection_groups" {
  for_each = local.network_rule_collection_groups_map

  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = each.value.rule_collections

    content {
      name     = network_rule_collection.value.name
      action   = network_rule_collection.value.action
      priority = network_rule_collection.value.priority

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.value.name
          source_addresses      = rule.value.source_addresses
          protocols             = rule.value.protocols
          destination_ports     = rule.value.destination_ports
          destination_addresses = rule.value.destination_addresses
        }
      }
    }
  }
}

locals {
  application_rule_collection_groups_map = {
    for rule_collection_group in var.application_rule_collection_groups : rule_collection_group.name => rule_collection_group
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "application_rule_collection_groups" {
  for_each = local.application_rule_collection_groups_map

  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = each.value.priority

  dynamic "application_rule_collection" {
    for_each = each.value.rule_collections

    content {
      name     = application_rule_collection.value.name
      action   = application_rule_collection.value.action
      priority = application_rule_collection.value.priority

      dynamic "rule" {
        for_each = application_rule_collection.value.rules

        content {
          name                  = rule.value.name
          source_addresses      = rule.value.source_addresses
          destination_fqdns     = rule.value.destination_fqdns
          destination_fqdn_tags = rule.value.destination_fqdn_tags

          dynamic "protocols" {
            for_each = rule.value.protocols

            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }
}

locals {
  nat_rule_collection_groups_map = {
    for rule_collection_group in var.nat_rule_collection_groups : rule_collection_group.name => rule_collection_group
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "nat_rule_collection_groups" {
  for_each = local.nat_rule_collection_groups_map

  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = each.value.priority

  dynamic "nat_rule_collection" {
    for_each = each.value.rule_collections

    content {
      name     = nat_rule_collection.value.name
      action   = nat_rule_collection.value.action
      priority = nat_rule_collection.value.priority

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules

        content {
          name                = rule.value.name
          source_addresses    = rule.value.source_addresses
          protocols           = rule.value.protocols
          destination_ports   = rule.value.destination_ports
          destination_address = rule.value.destination_address
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
}