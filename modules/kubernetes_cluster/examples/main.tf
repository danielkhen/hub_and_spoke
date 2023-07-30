module "aks" {
  source = "github.com/danielkhen/kubernetes_cluster_module"

  name                    = "example-aks"
  location                = "westeurope"
  resource_group_name     = azurerm_resource_group.example.name
  node_resource_group     = "example-aks-rg"
  dns_prefix              = "example-aks-dns"
  private_cluster_enabled = true
  network_plugin          = "kubenet"
  service_cidr            = "172.0.0.0/16"
  dns_service_ip          = "172.0.0.10"
  container_registry_id   = azurerm_container_registry.example.id

  # View variable documentation
  default_node_pool = local.default_node_pool
  node_pools        = local.node_pools

  log_analytics_enabled = true
  log_analytics_id      = azurerm_log_analytics_workspace.example.id
}