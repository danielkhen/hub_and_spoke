resource "azurerm_storage_account" "storage" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  account_kind                  = var.account_kind
  access_tier                   = var.access_tier
  enable_https_traffic_only     = var.enable_https_traffic_only
  public_network_access_enabled = var.public_network_access_enabled

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  storage_account_diagnostic_name = "${azurerm_storage_account.storage.name}-diagnostic"
}

module "storage_diagnostic" {
  source = "github.com/danielkhen/diagnostic_setting_module"

  name                       = local.storage_account_diagnostic_name
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = var.log_analytics_id
}

locals {
  subresources = ["blob", "file", "table", "queue"]
  subresources_diagnostic_map = {
    for subresource in local.subresources : subresource => {
      name               = "${azurerm_storage_account.storage.name}-${subresource}-diagnostic"
      target_resource_id = "${azurerm_storage_account.storage.id}/${subresource}Services/default/"
    }
  }
}

module "subresources_diagnostics" {
  source   = "github.com/danielkhen/diagnostic_setting_module"
  for_each = local.subresources_diagnostic_map

  name                       = each.value.name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = var.log_analytics_id
}

locals {
  private_endpoints_map = { for subresource in var.private_endpoints : subresource.name => subresource }
}

module "subresources_private_endpoints" {
  source   = "github.com/danielkhen/private_endpoint_module"
  for_each = var.private_endpoint_enabled ? local.private_endpoints_map : {}

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  nic_name            = each.value.nic_name
  private_dns_enabled = var.private_dns_enabled
  dns_name            = each.value.dns_name
  log_analytics_id    = var.log_analytics_id

  resource_id      = azurerm_storage_account.storage.id
  subresource_name = each.value.subresource_name
  subnet_id        = var.private_endpoints_subnet_id
  vnet_links       = var.vnet_links
}