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
  monitor_network_security_groups     = jsondecode(templatefile("./objects/monitor/network_security_groups.json", local.nsg_vars))
  monitor_network_security_groups_map = { for nsg in local.monitor_network_security_groups : nsg.name => nsg }
}

module "monitor_network_security_groups" {
  source   = "github.com/danielkhen/network_security_group_module"
  for_each = local.monitor_network_security_groups_map

  name                   = each.value.name
  location               = local.location
  resource_group_name    = azurerm_resource_group.monitor.name
  network_security_rules = each.value.network_security_rules

  log_analytics_id = module.hub_log_analytics.id
}

locals {
  monitor_route_tables     = jsondecode(templatefile("./objects/monitor/route_tables.json", local.route_table_vars))
  monitor_route_tables_map = { for rt in local.monitor_route_tables : rt.name => rt }
}

module "monitor_route_tables" {
  source   = "github.com/danielkhen/route_table_module"
  for_each = local.monitor_route_tables_map

  name                = each.value.name
  location            = local.location
  resource_group_name = azurerm_resource_group.monitor.name
  routes              = each.value.routes
}


locals {
  monitor_vnet_name          = "${local.prefix}-monitor-vnet"
  monitor_vnet_address_space = ["10.2.0.0/16"]
  monitor_vnet_subnets_map = {
    MonitorSubnet = {
      address_prefixes       = ["10.2.0.0/24"]
      network_security_group = "monitor-MonitorSubnet-nsg"
      route_table            = "monitor-rt"
    }
  }
  monitor_vnet_subnets = [
    for name, subnet in local.monitor_vnet_subnets_map : merge(subnet, {
      name                               = name
      network_security_group_id          = can(subnet.network_security_group) ? module.monitor_network_security_groups[subnet.network_security_group].id : null
      route_table_id                     = can(subnet.route_table) ? module.monitor_route_tables[subnet.route_table].id : null
      network_security_group_association = can(subnet.network_security_group)
      route_table_association            = can(subnet.route_table)
    })
  ]
}

module "monitor_virtual_network" {
  source = "github.com/danielkhen/virtual_network_module"

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
  monitor_vm_role_assignments = jsondecode(templatefile("./objects/monitor/vm_role_assignments.json", {
    resource_ids = {
      hub_log_analytics      = module.hub_log_analytics.id
      activity_log_analytics = data.azurerm_log_analytics_workspace.activity_log_analytics.id
    }
  }))
}

module "monitor_vm" {
  source = "github.com/danielkhen/virtual_machine_module"

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

  log_analytics_id = module.hub_log_analytics.id
}

locals {
  monitor_vm_dns_name    = "monitor.net"
  monitor_vm_record_name = "grafana"
  monitor_vm_vnet_links = [
    {
      vnet_id = module.hub_virtual_network.id
      name    = "hub-link"
    }
  ]
  monitor_vm_record_type = "a"
}

module "monitor_vm_record" {
  source = "github.com/danielkhen/dns_record_module"

  resource_group_name = azurerm_resource_group.monitor.name
  dns_name            = local.monitor_vm_dns_name
  name                = local.monitor_vm_record_name
  records             = [module.monitor_vm.private_ips[0]]
  vnet_links          = local.monitor_vm_vnet_links
  record_type         = local.monitor_vm_record_type
}