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
  dns_servers         = [module.ipam.hub.private_ip_addresses.firewall]
}

locals {
  work_storage_name                     = "${local.prefix}workstorage"
  work_storage_account_tier             = "Standard"
  work_storage_account_replication_type = "LRS"
  work_storage_private_endpoints = jsondecode(templatefile("./objects/work/storage_private_endpoints.json", {
    storage_account_name = local.work_storage_name
  }))
  work_storage_private_endpoints_enabled     = true
  work_storage_private_endpoints_dns_enabled = true

  work_storage_vnet_links = [
    {
      vnet_id = module.hub_virtual_network.id
      name    = "hub-link"
    }
  ]
}

module "work_storage_account" {
  source = "github.com/danielkhen/storage_account_module"

  name                        = local.work_storage_name
  location                    = local.location
  resource_group_name         = azurerm_resource_group.work.name
  account_tier                = local.work_storage_account_tier
  account_replication_type    = local.work_storage_account_replication_type
  log_analytics_id            = module.hub_log_analytics.id
  private_endpoint_enabled    = local.work_storage_private_endpoints_enabled
  private_dns_enabled         = local.work_storage_private_endpoints_dns_enabled
  private_endpoints_subnet_id = module.work_virtual_network.subnet_ids["StorageSubnet"]
  vnet_links                  = local.work_storage_vnet_links
  private_endpoints           = local.work_storage_private_endpoints
}

locals {
  work_aks_dns_name = "privatelink.westeurope.azmk8s.io"

  work_aks_vnet_links = [
    {
      vnet_id = module.hub_virtual_network.id
      name    = "hub-link"
    }
  ]
}

module "work_aks_private_dns_zone" {
  source = "github.com/danielkhen/private_dns_zone_module"

  name                = local.work_aks_dns_name
  resource_group_name = azurerm_resource_group.work.name
  vnet_links          = local.work_aks_vnet_links
}

locals {
  work_aks_identity_name = "${local.prefix}-work-aks-identity"

  work_aks_role_assignments = [
    {
      name  = "dns_role"
      scope = module.work_aks_private_dns_zone.id
      role  = "Private DNS Zone Contributor"
    },
    {
      name  = "acr_role"
      scope = module.hub_acr.id
      role  = "AcrPush"
    },
    {
      name  = "work_vnet_role"
      scope = module.work_virtual_network.id
      role  = "Network Contributor"
    }
  ]
}

module "work_aks_user_assigned_identity" {
  source = "github.com/danielkhen/user_assigned_identity_module"

  name                = local.work_aks_identity_name
  location            = local.location
  resource_group_name = azurerm_resource_group.work.name
  role_assignments    = local.work_aks_role_assignments
}

locals {
  work_aks_name                       = "${local.prefix}-work-aks"
  work_aks_node_resource_group        = "${local.prefix}-work-aks-rg"
  work_aks_network_plugin             = "azure"
  work_aks_max_node_provisioning_time = "60m"
  work_aks_identity_type              = "UserAssigned"

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
  private_dns_zone_id        = module.work_aks_private_dns_zone.id
  identity_type              = local.work_aks_identity_type
  user_assigned_identities   = [module.work_aks_user_assigned_identity.id]
  log_analytics_id           = module.hub_log_analytics.id

  # Depends on the firewall to allow Azure Kubernetes Services and the peerings to pass the traffic.
  # Even after the firewall is provisioned there is a delay until it starts working, thus we need
  # The max_node_provisioning_time to increase the time the aks waits until failure.
  depends_on = [module.hub_firewall, module.hub_to_work_peerings]
}

locals {
  work_vm_identity_name = "${local.prefix}-work-vm-identity"

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

module "work_vm_user_assigned_identity" {
  source = "github.com/danielkhen/user_assigned_identity_module"

  name                = local.work_vm_identity_name
  location            = local.location
  resource_group_name = azurerm_resource_group.work.name
  role_assignments    = local.work_vm_role_assignments
}

locals {
  work_vm_name           = "${local.prefix}-work-vm"
  work_vm_size           = "Standard_B2s"
  work_vm_os_type        = "Linux"
  work_vm_admin_username = "daniel"
  work_vm_identity_type  = "UserAssigned"

  work_vm_os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  work_vm_source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

module "work_vm" {
  source = "github.com/danielkhen/virtual_machine_module"

  name                   = local.work_vm_name
  location               = local.location
  resource_group_name    = azurerm_resource_group.work.name
  size                   = local.work_vm_size
  subnet_id              = module.work_virtual_network.subnet_ids["WorkSubnet"]
  os_type                = local.work_vm_os_type
  os_disk                = local.work_vm_os_disk
  source_image_reference = local.work_vm_source_image_reference
  log_analytics_id       = module.hub_log_analytics.id

  admin_username = local.work_vm_admin_username
  admin_password = var.vm_admin_password

  identity_type            = local.work_vm_identity_type
  user_assigned_identities = [module.work_vm_user_assigned_identity.id]
}