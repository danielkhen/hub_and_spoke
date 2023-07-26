locals {
  location            = "westeurope"
  resource_group_name = "dtf-kubernetes-cluster-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  aks_name           = "aks"
  aks_network_plugin = "kubenet"
  aks_service_cidr   = "172.0.0.0/16"
  aks_dns_service_ip = "172.0.0.10"

  aks_node_pools = [
    {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_B2s"
      default    = true
    }
  ]
}

module "aks" {
  source = "../"

  name                = local.aks_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  network_plugin      = local.aks_network_plugin
  service_cidr        = local.aks_service_cidr
  dns_service_ip      = local.aks_dns_service_ip
  node_pools          = local.aks_node_pools
}