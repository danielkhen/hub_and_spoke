locals {
  default_node_pool = [for node_pool in var.node_pools : node_pool if node_pool.default][0]
  identity_type     = "SystemAssigned"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  node_resource_group     = var.node_resource_group
  private_cluster_enabled = var.private_cluster_enabled
  dns_prefix              = var.dns_prefix == null ? var.name : var.dns_prefix

  network_profile {
    network_plugin = var.network_plugin
  }

  default_node_pool {
    name                  = local.default_node_pool.name
    node_count            = local.default_node_pool.node_count
    vm_size               = local.default_node_pool.vm_size
    enable_auto_scaling   = local.default_node_pool.enable_auto_scaling
    vnet_subnet_id        = local.default_node_pool.vnet_subnet_id
    enable_node_public_ip = local.default_node_pool.enable_node_public_ip
    max_pods              = local.default_node_pool.max_pods
    max_count             = local.default_node_pool.max_count
    min_count             = local.default_node_pool.min_count
    os_sku                = local.default_node_pool.os_sku
  }

  dynamic "identity" {
    for_each = var.container_registry_id == null ? [] : [true]

    content {
      type = local.identity_type
    }
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  node_pools_map = { for node_pool in var.node_pools : node_pool.name => node_pool if !node_pool.default }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  for_each = local.node_pools_map

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  enable_auto_scaling   = each.value.enable_auto_scaling
  vnet_subnet_id        = each.value.vnet_subnet_id
  enable_node_public_ip = each.value.enable_node_public_ip
  max_pods              = each.value.max_pods
  max_count             = each.value.max_count
  min_count             = each.value.min_count
  os_sku                = each.value.os_sku
  os_type               = each.value.os_type
}

locals {
  role_definition_name = "AcrPull"
}

resource "azurerm_role_assignment" "acr_role" {
  count = var.container_registry_id == null ? 0 : 1

  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = local.role_definition_name
  scope                = var.container_registry_id
}

module "aks-diagnostics" {
  source = "github.com/danielkhen/diagnostic_setting_module"
  count = var.log_analytics_enabled ? 1 : 0

  name                       = var.diagnostics_name
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = var.log_analytics_id
}