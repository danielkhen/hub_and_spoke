resource "azurerm_dns_zone" "dns_zone" {
  count = var.is_private ? 0 : 1

  name                = var.dns_name
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  count = var.is_private ? 1 : 0

  name                = var.dns_name
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  vnet_links_map = { for link in var.vnet_links : link.name => link }
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each = var.is_private ? local.vnet_links_map : {}

  name                  = each.value.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone[0].name
  virtual_network_id    = each.value.vnet_id

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}


resource "azurerm_dns_a_record" "a_record" {
  count = !var.is_private && var.record_type == "a" ? 1 : 0

  name                = var.name
  zone_name           = azurerm_dns_zone.dns_zone[0].name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = var.records

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}


resource "azurerm_private_dns_a_record" "private_a_record" {
  count = var.is_private && var.record_type == "a" ? 1 : 0

  name                = var.name
  zone_name           = azurerm_private_dns_zone.private_dns_zone[0].name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = var.records

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_dns_aaaa_record" "aaaa_record" {
  count = !var.is_private && var.record_type == "aaaa" ? 1 : 0

  name                = var.name
  zone_name           = azurerm_dns_zone.dns_zone[0].name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = var.records

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}


resource "azurerm_private_dns_aaaa_record" "private_aaaa_record" {
  count = var.is_private && var.record_type == "aaaa" ? 1 : 0

  name                = var.name
  zone_name           = azurerm_private_dns_zone.private_dns_zone[0].name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = var.records

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}