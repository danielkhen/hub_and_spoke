locals {
  work_rg_name = "${local.prefix}-work-spoke"
}

resource "azurerm_resource_group" "work" {
  name     = local.work_rg_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  work_network_security_groups     = jsondecode(file("./objects/work/network_security_groups.json"))
  work_network_security_groups_map = { for nsg in local.work_network_security_groups : nsg.name => nsg }
}

module "work_network_security_groups" {
  source   = "./modules/network_security_group"
  for_each = local.work_network_security_groups_map

  name                   = each.value.name
  location               = local.location
  resource_group_name    = azurerm_resource_group.work.name
  network_security_rules = each.value.network_security_rules

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  work_route_tables     = jsondecode(templatefile("./objects/work/route_tables.json", local.route_table_vars))
  work_route_tables_map = { for rt in local.work_route_tables : rt.name => rt }
}

module "work_route_tables" {
  source   = "./modules/route_table"
  for_each = local.work_route_tables_map

  name                = each.value.name
  location            = local.location
  resource_group_name = azurerm_resource_group.work.name
  routes              = each.value.routes
}

locals {
  work_vnet_name          = "${local.prefix}-work-vnet"
  work_vnet_address_space = ["10.1.0.0/16"]
  work_vnet_subnets = [
    {
      name                      = "WorkSubnet"
      address_prefixes          = ["10.1.0.0/24"]
      network_security_group_id = module.work_network_security_groups["work-WorkSubnet-nsg"].id
      route_table_id            = module.work_route_tables["work-rt"].id
    },
    {
      name                      = "StorageSubnet"
      address_prefixes          = ["10.1.1.0/24"]
      network_security_group_id = module.work_network_security_groups["work-StorageSubnet-nsg"].id
      route_table_id            = module.work_route_tables["work-rt"].id
    },
    {
      name                      = "AKSSubnet"
      address_prefixes          = ["10.1.2.0/24"]
      network_security_group_id = module.work_network_security_groups["work-AKSSubnet-nsg"].id
      route_table_id            = module.work_route_tables["work-rt"].id
    }
  ]
}

module "work_virtual_network" {
  source = "./modules/virtual_network"

  name                = local.work_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.work.name
  address_space       = local.work_vnet_address_space
  subnets             = local.work_vnet_subnets
}

locals {
  work_storage_name                    = "${local.prefix}workstorage"
  hub_storage_account_tier             = "Standard"
  hub_storage_account_replication_type = "LRS"
}

module "work_private_storage" {
  source = "./modules/storage_account"

  name                     = local.work_storage_name
  location                 = local.location
  resource_group_name      = azurerm_resource_group.work.name
  account_tier             = local.hub_storage_account_tier
  account_replication_type = local.hub_storage_account_replication_type

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  work_storage_vnet_links = [
    {
      vnet_id = module.work_virtual_network.id
      name    = "work-link"
    }
  ]
  work_storage_subresources     = jsondecode(file("./objects/work/storage_subresources.json"))
  work_storage_subresources_map = { for subresource in local.work_storage_subresources : subresource.name => subresource }
}

module "work_subresources_pes" {
  source   = "./modules/private_endpoint_w_dns_zone"
  for_each = local.work_storage_subresources_map

  location            = local.location
  resource_group_name = azurerm_resource_group.work.name
  dns_name            = each.value.dns_name
  nic_name            = each.value.nic_name
  pe_name             = each.value.pe_name

  resource_id      = module.work_private_storage.id
  subresource_name = each.value.name
  subnet_id        = module.work_virtual_network.subnet_ids["StorageSubnet"]
  vnet_links       = local.work_storage_vnet_links

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  work_aks_name                = "${local.prefix}-work-aks"
  work_aks_node_resource_group = "${local.prefix}-work-aks-rg"
  work_aks_network_plugin      = "azure"
  work_aks_node_pools = [
    #TODO move to file after templatefile
    {
      name           = "default"
      node_count     = 1
      vm_size        = "Standard_B2s"
      vnet_subnet_id = module.work_virtual_network.subnet_ids["AKSSubnet"]
      default        = true
    }
  ]
}

module "work_aks" {
  source = "./modules/kubernetes_cluster"

  name                  = local.work_aks_name
  location              = local.location
  resource_group_name   = azurerm_resource_group.work.name
  node_resource_group   = local.work_aks_node_resource_group
  network_plugin        = local.work_aks_network_plugin
  container_registry_id = azurerm_container_registry.hub_acr.id
  node_pools            = local.work_aks_node_pools

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  work_vm_name     = "${local.prefix}-work-vm"
  work_vm_nic_name = "${local.prefix}-work-vm-nic"
  work_vm_os_disk  = merge(local.vm_os_disk, { name = "${local.prefix}-work-vm-os-disk" })
  work_vm_role_assignments = [ #TODO move to template file
    {
      scope = module.work_aks.id
      role  = "Azure Kubernetes Service Cluster User Role"
    },
    {
      scope = azurerm_container_registry.hub_acr.id
      role  = "AcrPush"
    }
  ]
}

module "work_vm" {
  source = "./modules/virtual_machine"

  name                   = local.work_vm_name
  location               = local.location
  resource_group_name    = azurerm_resource_group.work.name
  size                   = local.vm_size
  nic_name               = local.work_vm_nic_name
  subnet_id              = module.work_virtual_network.subnet_ids["WorkSubnet"]
  os_type                = local.vm_os_type
  os_disk                = local.work_vm_os_disk
  source_image_reference = local.vm_source_image_reference

  admin_username = local.vm_admin_username
  admin_password = var.vm_admin_password

  identity_type    = local.vm_identity_type
  role_assignments = local.work_vm_role_assignments

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}