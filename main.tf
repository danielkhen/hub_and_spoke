#TODO for each spoke a different file
# 1. resource group will repeat, as well as vnet, vm, etc.
# 2. hard values should be locals, called before their usage
# 3. all module sources should pull from git.
# default file structure. file for spoke (usage), common.tf, variables.tf, provider.tf , versions.tf
# module calls should be ordered by creation
# next cr - ipam, tests.

#data "azurerm_log_analytics_workspace" "activity-log-analytics" {
#
#  name                = var.activity_log_analytics_name
#  resource_group_name = var.activity_log_analytics_resource_group
#}

#module "virtual_networks" {
#  source   = "virtual_network"
#  for_each = local.virtual_networks
#
#  location                       = var.location
#  name                           = "${var.prefix}-${each.value.name}"
#  resource_group_name            = azurerm_resource_group.resource_groups[each.key].name
#  address_space                  = each.value.address_space
#  subnets                        = each.value.subnets
#  default_network_security_rules = concat(each.value.vnet_network_security_rules, local.default_network_security_rules)
#  log_analytics_id               = module.log_analytics.id
#}

#module "vpn_gateway" {
#  source = "virtual_network_gateway"
#
#  location            = var.location
#  resource_group_name = azurerm_resource_group.hub.name
#  name                = "${var.prefix}-hub-vng"
#  default_pip_name    = "${var.prefix}-hub-vng-default-pip"
#  aa_pip_name         = "${var.prefix}-hub-vng-aa-pip"
#
#  sku               = var.vng_sku
#  generation        = var.vng_generation
#  vpn_address_space = var.vpn_address_space
#  subnet_id         = module.hub_virtual_network.subnet_ids["GatewaySubnet"]
#  aad_credentials   = local.aad_credentials
#
#  log_analytics_id = module.log_analytics.id
#}

#module "hub_to_work_peerings" {
#  source = "./virtual_network_peerings"
#
#  resource_group_name = azurerm_resource_group.hub.name
#  vnet_name           = module.hub_virtual_network.name
#  vnet_id             = module.hub_virtual_network.id
#
#  remote_resource_group_name = azurerm_resource_group.work.name
#  remote_vnet_name           = module.work_virtual_network.name
#  remote_vnet_id             = module.work_virtual_network.id
#
#  depends_on = [module.hub_vpn_gateway]
#}
#
#module "hub_to_monitor_peerings" {
#  source = "./virtual_network_peerings"
#
#  resource_group_name = azurerm_resource_group.hub.name
#  vnet_name           = module.hub_virtual_network.name
#  vnet_id             = module.hub_virtual_network.id
#
#  remote_resource_group_name = azurerm_resource_group.monitor.name
#  remote_vnet_name           = module.monitor_virtual_network.name
#  remote_vnet_id             = module.monitor_virtual_network.id
#
#  depends_on = [module.hub_vpn_gateway]
#}

#module "firewall_policy" {
#  source = "./firewall_policy"
#
#  location                     = var.location
#  name                         = "${var.prefix}-hub-fw-pl"
#  resource_group_name          = azurerm_resource_group.hub.name
#  network_rule_collections     = local.network_rule_collections
#  application_rule_collections = local.application_rule_collections
#  nat_rule_collections         = local.nat_rule_collections
#}

#module "firewall" {
#  source = "./firewall"
#
#  location                  = var.location
#  resource_group_name       = azurerm_resource_group.hub.name
#  name                      = "${var.prefix}-hub-fw"
#  public_ip_name            = "${var.prefix}-hub-fw-pip"
#  management_public_ip_name = "${var.prefix}-hub-fw-mng-pip"
#
#  sku_tier                      = var.firewall_sku_tier
#  policy_id                     = module.firewall_policy.policy_id
#  firewall_subnet_id            = module.hub_virtual_network.subnet_ids["AzureFirewallSubnet"]
#  firewall_management_subnet_id = module.hub_virtual_network.subnet_ids["AzureFirewallManagementSubnet"]
#
#  log_analytics_id = module.hub_log_analytics.id
#}

#module "route_tables" {
#  source = "route_table"
#
#  for_each = local.route_tables
#
#  location            = var.location
#  name                = "${var.prefix}-${each.key}"
#  resource_group_name = azurerm_resource_group.resource_groups[each.value.resource_group_key].name
#
#  next_hop_ip_address = module.firewall.private_ip_address
#  routes              = each.value.routes
#  subnet_ids = {
#    for subnet in each.value.subnets : subnet =>
#    module.virtual_networks[each.value.resource_group_key].subnet_ids[subnet]
#  }
#}

#module "storage_account" {
#  source = "./storage_account"
#
#  name                     = "${var.prefix}workstorage"
#  location                 = var.location
#  resource_group_name      = azurerm_resource_group.work.name
#  account_tier             = var.storage_account_tier
#  account_replication_type = var.storage_account_replication_type
#
#  subnet_id             = module.work_virtual_network.subnet_ids["StorageSubnet"]
#  virtual_network_name  = module.work_virtual_network.name
#  virtual_network_id    = module.work_virtual_network.id
#  subresource_dns_zones = local.storage_subresource_dns_zones
#
#  log_analytics_id = module.hub_log_analytics.id
#}
#
#module "container_registry" {
#  source = "./private_container_registry"
#
#  location            = var.location
#  name                = "${var.prefix}hubacr"
#  resource_group_name = azurerm_resource_group.hub.name
#
#  subnet_id     = module.hub_virtual_network.subnet_ids["ACRSubnet"]
#  dns_zone_name = var.acr_dns_zone_name
#
#  virtual_network_links = {
#    hub  = module.hub_virtual_network.id,
#    work = module.work_virtual_network.id
#  }
#}
#
#module "kubernetes_cluster" {
#  source = "./kubernetes_cluster"
#
#  location              = var.location
#  name                  = "${var.prefix}-work-aks"
#  resource_group_name   = azurerm_resource_group.work.name
#  node_count            = var.aks_node_count
#  subnet_id             = module.work_virtual_network.subnet_ids["AKSSubnet"]
#  vm_size               = var.vm_size
#  container_registry_id = module.container_registry.id
#
#  log_analytics_id = module.hub_log_analytics.id
#}
#
#module "work_vm" {
#  source = "./virtual_machine"
#
#  location            = var.location
#  name                = "${var.prefix}-work-vm"
#  resource_group_name = azurerm_resource_group.work.name
#
#  size           = var.vm_size
#  subnet_id      = module.work_virtual_network.subnet_ids["WorkSubnet"]
#  admin_username = var.vm_admin_username
#  admin_password = var.vm_admin_password
#
#  log_analytics_id = module.hub_log_analytics.id
#
#  role_assignments = {
#    "aks-access" = {
#      id   = module.kubernetes_cluster.id
#      role = "Azure Kubernetes Service Cluster User Role"
#    }
#
#    "acr-access" = {
#      id   = module.container_registry.id
#      role = "AcrPush"
#    }
#  }
#}
#
#module "monitor_vm" { #TODO add dns zone
#  source = "./virtual_machine"
#
#  location            = var.location
#  name                = "${var.prefix}-monitor-vm"
#  resource_group_name = azurerm_resource_group.monitor.name
#
#  size           = var.vm_size
#  subnet_id      = module.monitor_virtual_network.subnet_ids["MonitorSubnet"]
#  admin_username = var.vm_admin_username
#  admin_password = var.vm_admin_password
#
#  log_analytics_id = module.hub_log_analytics.id
#
#  role_assignments = {
#    "logs" = {
#      id   = module.hub_log_analytics.id
#      role = "Reader"
#    }
#
#    "activity_logs" = {
#      id   = data.azurerm_log_analytics_workspace.activity_log_analytics.id
#      role = "Reader"
#    }
#  }
#}