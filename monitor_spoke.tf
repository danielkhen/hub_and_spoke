locals {
  monitor_rg_name = "${local.prefix}-monitor-spoke"
}

resource "azurerm_resource_group" "monitor" {
  name     = local.monitor_rg_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  monitor_network_security_groups     = jsondecode(file("./objects/monitor/network_security_groups.json"))
  monitor_network_security_groups_map = { for nsg in local.monitor_network_security_groups : nsg.name => nsg }
}

module "monitor_network_security_groups" {
  source   = "./modules/network_security_group"
  for_each = local.monitor_network_security_groups_map

  name                   = each.value.name
  location               = local.location
  resource_group_name    = azurerm_resource_group.monitor.name
  network_security_rules = each.value.network_security_rules

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  monitor_route_tables     = jsondecode(file("./objects/monitor/route_tables.json")) #TODO templatefile
  monitor_route_tables_map = { for rt in local.monitor_route_tables : rt.name => rt }
}

module "monitor_route_tables" {
  source   = "./modules/route_table"
  for_each = local.monitor_route_tables_map

  name                = each.value.name
  location            = local.location
  resource_group_name = azurerm_resource_group.monitor.name
  routes              = each.value.routes
}


locals {
  monitor_vnet_name          = "${local.prefix}-monitor-vnet"
  monitor_vnet_address_space = ["10.2.0.0/16"]
  monitor_vnet_subnets = [
    {
      name                      = "MonitorSubnet"
      address_prefixes          = ["10.2.0.0/24"]
      network_security_group_id = module.monitor_network_security_groups["monitor-MonitorSubnet-nsg"].id
      route_table_id            = module.monitor_route_tables["monitor-rt"].id
    }
  ]
}

module "monitor_virtual_network" {
  source = "./modules/virtual_network"

  name                = local.monitor_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.monitor.name
  address_space       = local.monitor_vnet_address_space
  subnets             = local.monitor_vnet_subnets
}

locals {
  monitor_vm_name     = "${local.prefix}-monitor-vm"
  monitor_vm_nic_name = "${local.prefix}-monitor-vm-nic"
  monitor_vm_os_disk  = merge(local.vm_os_disk, { name = "${local.prefix}-monitor-vm-os-disk" })
  monitor_vm_role_assignments = [ #TODO move to template file
    {
      scope   = module.hub_log_analytics.id
      role = "Reader"
    },
    {
      scope   = data.azurerm_log_analytics_workspace.activity_log_analytics.id
      role = "Reader"
    }
  ]
}

module "monitor_vm" {
  source = "./modules/virtual_machine"

  name                   = local.monitor_vm_name
  location               = local.location
  resource_group_name    = azurerm_resource_group.monitor.name
  size                   = local.vm_size
  nic_name               = local.monitor_vm_nic_name
  subnet_id              = module.monitor_virtual_network.subnet_ids["MonitorSubnet"]
  os_type                = local.vm_os_type
  os_disk                = local.monitor_vm_os_disk
  source_image_reference = local.vm_source_image_reference

  admin_username = local.vm_admin_username
  admin_password = var.vm_admin_password

  identity_type    = local.vm_identity_type
  role_assignments = local.monitor_vm_role_assignments

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}