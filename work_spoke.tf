locals {
  work_rg_name = "${local.prefix}-work-spoke-rg"
}

resource "azurerm_resource_group" "work" {
  name     = local.work_rg_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  work_network_security_groups     = jsondecode(templatefile("./objects/work/network_security_groups.json", module.ipam))
  work_network_security_groups_map = { for nsg in local.work_network_security_groups : nsg.name => nsg }
}

module "work_network_security_groups" {
  source   = "github.com/danielkhen/network_security_group_module"
  for_each = local.work_network_security_groups_map

  name                   = each.value.name
  location               = local.location
  resource_group_name    = azurerm_resource_group.work.name
  network_security_rules = each.value.network_security_rules
  log_analytics_id       = module.hub_log_analytics.id
}

locals {
  work_route_tables     = jsondecode(templatefile("./objects/work/route_tables.json", module.ipam))
  work_route_tables_map = { for rt in local.work_route_tables : rt.name => rt }
}

module "work_route_tables" {
  source   = "github.com/danielkhen/route_table_module"
  for_each = local.work_route_tables_map

  name                = each.value.name
  location            = local.location
  resource_group_name = azurerm_resource_group.work.name
  routes              = each.value.routes
}

locals {
  work_vnet_name = "${local.prefix}-work-vnet"

  work_vnet_subnets = [
    {
      name                   = "WorkSubnet"
      network_security_group = "work-WorkSubnet-nsg"
      route_table            = "work-rt"
    },
    {
      name                   = "StorageSubnet"
      network_security_group = "work-StorageSubnet-nsg"
      route_table            = "work-rt"
    },
    {
      name                   = "AKSSubnet"
      network_security_group = "work-AKSSubnet-nsg"
      route_table            = "work-rt"
    }
  ]

  work_vnet_subnets_populated = [
    for subnet in local.work_vnet_subnets : merge(subnet, {
      address_prefix            = module.ipam.work.subnet_address_prefixes[subnet.name]
      network_security_group_id = can(subnet.network_security_group) ? module.work_network_security_groups[subnet.network_security_group].id : ""
      route_table_id            = can(subnet.route_table) ? module.work_route_tables[subnet.route_table].id : ""
    })
  ]
}

module "work_virtual_network" {
  source = "github.com/danielkhen/virtual_network_module"

  name                = local.work_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.work.name
  address_space       = [module.ipam.work.vnet_address_prefix]
  subnets             = local.work_vnet_subnets_populated
}

locals {
  work_storage_name                    = "${local.prefix}workstorage"
  hub_storage_account_tier             = "Standard"
  hub_storage_account_replication_type = "LRS"
  work_storage_private_endpoints = jsondecode(templatefile("./objects/work/storage_private_endpoints.json", {
    storage_account_name = local.work_storage_name
  }))

  work_storage_vnet_links = [
    {
      vnet_id = module.work_virtual_network.id
      name    = "work-link"
    }
  ]
}

module "work_storage_account" {
  source = "github.com/danielkhen/storage_account_module"

  name                     = local.work_storage_name
  location                 = local.location
  resource_group_name      = azurerm_resource_group.work.name
  account_tier             = local.hub_storage_account_tier
  account_replication_type = local.hub_storage_account_replication_type
  log_analytics_id         = module.hub_log_analytics.id

  private_endpoint_enabled    = local.private_endpoints_enabled
  private_dns_enabled         = local.private_endpoints_dns_enabled
  private_endpoints_subnet_id = module.work_virtual_network.subnet_ids["StorageSubnet"]
  vnet_links                  = local.work_storage_vnet_links
  private_endpoints           = local.work_storage_private_endpoints
}


locals {
  work_aks_name                       = "${local.prefix}-work-aks"
  work_aks_node_resource_group        = "${local.prefix}-work-aks-rg"
  work_aks_network_plugin             = "azure"
  work_aks_max_node_provisioning_time = "60m"

  work_aks_default_node_pool = {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = module.work_virtual_network.subnet_ids["AKSSubnet"]
    default        = true
  }
}

module "work_aks" {
  source = "github.com/danielkhen/kubernetes_cluster_module"

  name                       = local.work_aks_name
  location                   = local.location
  resource_group_name        = azurerm_resource_group.work.name
  node_resource_group        = local.work_aks_node_resource_group
  network_plugin             = local.work_aks_network_plugin
  default_node_pool          = local.work_aks_default_node_pool
  container_registry_id      = module.hub_acr.id
  max_node_provisioning_time = local.work_aks_max_node_provisioning_time
  log_analytics_id           = module.hub_log_analytics.id

  # Depends on the firewall to allow Azure Kubernetes Services and the peerings to pass the traffic
  depends_on = [module.hub_firewall, module.hub_to_work_peerings]
}

locals {
  work_vm_name     = "${local.prefix}-work-vm"
  work_vm_nic_name = "${local.prefix}-work-vm-nic"
  work_vm_os_disk  = merge(local.vm_os_disk, { name = "${local.prefix}-work-vm-os-disk" })

  work_vm_role_assignments = [
    {
      name  = "aks_role"
      scope = module.work_aks.id
      role  = "Azure Kubernetes Service Cluster User Role"
    },
    {
      name  = "acr_role"
      scope = module.hub_acr.id
      role  = "AcrPush"
    }
  ]
}

module "work_vm" {
  source = "github.com/danielkhen/virtual_machine_module"

  name                   = local.work_vm_name
  location               = local.location
  resource_group_name    = azurerm_resource_group.work.name
  size                   = local.vm_size
  subnet_id              = module.work_virtual_network.subnet_ids["WorkSubnet"]
  os_type                = local.vm_os_type
  os_disk                = local.work_vm_os_disk
  source_image_reference = local.vm_source_image_reference
  log_analytics_id       = module.hub_log_analytics.id

  admin_username = local.vm_admin_username
  admin_password = var.vm_admin_password

  identity_type    = local.vm_identity_type
  role_assignments = local.work_vm_role_assignments
}