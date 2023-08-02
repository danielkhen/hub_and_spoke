locals {
  monitor_rg_name = "${local.prefix}-monitor-spoke-rg"
}

resource "azurerm_resource_group" "monitor" {
  name     = local.monitor_rg_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  monitor_network_security_groups     = jsondecode(templatefile("./objects/monitor/network_security_groups.json", module.ipam))
  monitor_network_security_groups_map = { for nsg in local.monitor_network_security_groups : nsg.name => nsg }
}

module "monitor_network_security_groups" {
  source   = "github.com/danielkhen/network_security_group_module"
  for_each = local.monitor_network_security_groups_map

  name                   = each.value.name
  location               = local.location
  resource_group_name    = azurerm_resource_group.monitor.name
  network_security_rules = each.value.network_security_rules
  log_analytics_id       = module.hub_log_analytics.id
}

locals {
  monitor_route_tables     = jsondecode(templatefile("./objects/monitor/route_tables.json", module.ipam))
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
  monitor_vnet_name = "${local.prefix}-monitor-vnet"

  monitor_vnet_subnets = [
    {
      name                   = "MonitorSubnet"
      network_security_group = "monitor-MonitorSubnet-nsg"
      route_table            = "monitor-rt"
    }
  ]

  monitor_vnet_subnets_populated = [
    for subnet in local.monitor_vnet_subnets : merge(subnet, {
      address_prefix            = module.ipam.monitor.subnet_address_prefixes[subnet.name]
      network_security_group_id = can(subnet.network_security_group) ? module.monitor_network_security_groups[subnet.network_security_group].id : ""
      route_table_id            = can(subnet.route_table) ? module.monitor_route_tables[subnet.route_table].id : ""
    })
  ]
}

module "monitor_virtual_network" {
  source = "github.com/danielkhen/virtual_network_module"

  name                = local.monitor_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.monitor.name
  address_space       = [module.ipam.monitor.vnet_address_prefix]
  subnets             = local.monitor_vnet_subnets_populated
}

locals {
  monitor_vm_name     = "${local.prefix}-monitor-vm"
  monitor_vm_nic_name = "${local.prefix}-monitor-vm-nic"
  monitor_vm_os_disk  = merge(local.vm_os_disk, { name = "${local.prefix}-monitor-vm-os-disk" })
  monitor_vm_role_assignments = [
    {
      name  = "hub-logs-role"
      scope = module.hub_log_analytics.id
      role  = "Reader"
    },
    {
      name  = "activity-logs-role"
      scope = data.azurerm_log_analytics_workspace.activity.id
      role  = "Reader"
    }
  ]
}

module "monitor_vm" {
  source = "github.com/danielkhen/virtual_machine_module"

  name                   = local.monitor_vm_name
  location               = local.location
  resource_group_name    = azurerm_resource_group.monitor.name
  size                   = local.vm_size
  subnet_id              = module.monitor_virtual_network.subnet_ids["MonitorSubnet"]
  os_type                = local.vm_os_type
  os_disk                = local.monitor_vm_os_disk
  source_image_reference = local.vm_source_image_reference
  log_analytics_id       = module.hub_log_analytics.id

  admin_username = local.vm_admin_username
  admin_password = var.vm_admin_password

  identity_type    = local.vm_identity_type
  role_assignments = local.monitor_vm_role_assignments
}

locals {
  monitor_vm_dns_name = "monitor.net"
  monitor_vm_a_records = [
    {
      name    = "grafana"
      ttl     = 300
      records = module.monitor_vm.private_ips
    }
  ]

  monitor_vm_vnet_links = [
    {
      vnet_id = module.hub_virtual_network.id
      name    = "hub-link"
    }
  ]
}

module "monitor_vm_dns_zone" {
  source = "github.com/danielkhen/private_dns_zone_module"

  name                = local.monitor_vm_dns_name
  resource_group_name = azurerm_resource_group.monitor.name
  a_records           = local.monitor_vm_a_records
}
#TODO learn about azure dns, dns tunneling