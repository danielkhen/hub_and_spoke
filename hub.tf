locals {
  hub_rg_name = "${local.prefix}-hub"
}

resource "azurerm_resource_group" "hub" {
  name     = local.hub_rg_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  hub_log_analytics_name = "${local.prefix}-hub-log-analytics-workspace"
  hub_log_analytics_sku  = "PerGB2018"
}

module "hub_log_analytics" {
  source = "./modules/log_analytics_workspace"

  name                = "${local.prefix}-hub-log-analytics-workspace"
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = local.hub_log_analytics_sku
  log_analytics       = true
}

locals {
  hub_network_security_groups     = jsondecode(file("./objects/hub/network_security_groups.json"))
  hub_network_security_groups_map = {for nsg in local.hub_network_security_groups : nsg.name => nsg}
}

module "hub_network_security_groups" {
  source   = "./modules/network_security_group"
  for_each = local.hub_network_security_groups_map

  name                   = each.value.name
  location               = local.location
  resource_group_name    = azurerm_resource_group.hub.name
  network_security_rules = each.value.network_security_rules

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  hub_route_tables     = jsondecode(file("./objects/hub/route_tables.json")) #TODO templatefile
  hub_route_tables_map = {for rt in local.hub_route_tables : rt.name => rt}
}

module "hub_route_tables" {
  source   = "./modules/route_table"
  for_each = local.hub_route_tables_map

  name                = each.value.name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  routes              = each.value.routes
}

locals {
  hub_vnet_name          = "${local.prefix}-hub-vnet"
  hub_vnet_address_space = ["10.0.0.0/16"]
  hub_vnet_subnets       = [
    {
      name                               = "GatewaySubnet"
      address_prefixes                   = ["10.0.0.0/24"]
      route_table_id                     = module.hub_route_tables["hub-gateway-rt"].id
      network_security_group_association = false
    },
    {
      name                               = "AzureFirewallSubnet"
      address_prefixes                   = ["10.0.1.0/24"]
      route_table_association            = false
      network_security_group_association = false
    },
    {
      name                               = "AzureFirewallManagementSubnet"
      address_prefixes                   = ["10.0.2.0/24"]
      route_table_association            = false
      network_security_group_association = false
    },
    {
      name                      = "ACRSubnet"
      address_prefixes          = ["10.0.3.0/24"]
      network_security_group_id = module.hub_network_security_groups["hub-ACRSubnet-nsg"].id
      route_table_id            = module.hub_route_tables["hub-rt"].id
    }
  ]
}

module "hub_virtual_network" {
  source = "./modules/virtual_network"

  name                = local.hub_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = local.hub_vnet_address_space
  subnets             = local.hub_vnet_subnets
}

locals {
  hub_vng_name              = "${local.prefix}-hub-vpn"
  hub_vng_type              = "Vpn"
  hub_vng_vpn_type          = "RouteBased"
  hub_vng_default_pip_name  = "${local.prefix}-hub-vpn-default-pip"
  hub_vng_aa_pip_name       = "${local.prefix}-hub-vpn-aa-pip"
  hub_vng_active_active     = true
  hub_vng_vpn_address_space = ["172.0.0.0/16"]
  hub_vng_sku               = "VpnGw1"
  hub_vng_generation        = "Generation1"
  aad_audience              = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}

module "hub_vpn_gateway" {
  source = "./modules/virtual_network_gateway"

  name                = local.hub_vng_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = local.hub_vng_sku
  generation          = local.hub_vng_generation
  type                = local.hub_vng_type
  vpn_type            = local.hub_vng_vpn_type

  default_pip_name = local.hub_vng_default_pip_name
  subnet_id        = module.hub_virtual_network.subnet_ids["GatewaySubnet"]
  active_active    = local.hub_vng_active_active
  aa_pip_name      = local.hub_vng_aa_pip_name

  vpn_address_space = local.hub_vng_vpn_address_space
  aad_tenant        = var.aad_tenant_id
  aad_audience      = local.aad_audience

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  hub_fw_pl_name               = "${local.prefix}-hub-fw-pl"
  hub_fw_pl_network_groups     = jsondecode(file("./objects/hub/network_rule_collection_groups.json"))
  hub_fw_pl_application_groups = jsondecode(file("./objects/hub/application_rule_collection_groups.json"))
  hub_fw_pl_nat_groups         = jsondecode(file("./objects/hub/nat_rule_collection_groups.json"))
}

module "hub_firewall_policy" {
  source = "./modules/firewall_policy"

  name                = local.hub_fw_pl_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name

  network_rule_collection_groups     = local.hub_fw_pl_network_groups
  application_rule_collection_groups = local.hub_fw_pl_application_groups
  nat_rule_collection_groups         = local.hub_fw_pl_nat_groups
}

locals {
  hub_fw_name                = "${local.prefix}-hub-fw"
  hub_fw_pip_name            = "${local.prefix}-hub-fw-pip"
  hub_fw_management_pip_name = "${local.prefix}-hub-fw-mng-pip"
  hub_firewall_sku_tier      = "Standard"
}

module "hub_firewall" {
  source = "./modules/firewall"

  name                = local.hub_fw_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_tier            = local.hub_firewall_sku_tier
  subnet_id           = module.hub_virtual_network.subnet_ids["AzureFirewallSubnet"]
  policy_id           = module.hub_firewall_policy.id
  public_ip_name      = local.hub_fw_pip_name

  forced_tunneling          = true
  management_public_ip_name = local.hub_fw_management_pip_name
  management_subnet_id      = module.hub_virtual_network.subnet_ids["AzureFirewallManagementSubnet"]

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}

locals {
  hub_acr_name = "${local.prefix}hubacr"
  hub_acr_sku  = "Premium"
}

resource "azurerm_container_registry" "hub_acr" {
  name                          = local.hub_acr_name
  location                      = local.location
  resource_group_name           = azurerm_resource_group.hub.name
  sku                           = local.hub_acr_sku
  public_network_access_enabled = false

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  hub_acr_dns_name       = "privatelink.azurecr.io"
  hub_acr_nic_name       = "${local.prefix}-hub-acr-nic"
  hub_acr_pe_name        = "${local.prefix}-hub-acr-pe"
  hub_acr_pe_subresource = "registry"
  hub_acr_vnet_links     = [
    {
      vnet_id = module.work_virtual_network.id
      name    = "work-link"
    },
    {
      vnet_id = module.hub_virtual_network.id
      name    = "hub-link"
    }
  ]
}

module "hub_acr_pe" {
  source = "./modules/private_endpoint_w_dns_zone"

  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  dns_name            = local.hub_acr_dns_name
  nic_name            = local.hub_acr_nic_name
  pe_name             = local.hub_acr_pe_name

  resource_id      = azurerm_container_registry.hub_acr.id
  subresource_name = local.hub_acr_pe_subresource
  subnet_id        = module.hub_virtual_network.subnet_ids["ACRSubnet"]
  vnet_links       = local.hub_acr_vnet_links

  log_analytics    = true
  log_analytics_id = module.hub_log_analytics.id
}