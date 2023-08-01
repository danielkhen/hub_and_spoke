locals {
  hub_rg_name = "${local.prefix}-hub-rg"
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
  source = "github.com/danielkhen/log_analytics_workspace_module"

  name                = local.hub_log_analytics_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = local.hub_log_analytics_sku
}

locals {
  hub_network_security_groups     = jsondecode(templatefile("./objects/hub/network_security_groups.json", local.network_vars))
  hub_network_security_groups_map = { for nsg in local.hub_network_security_groups : nsg.name => nsg }
}

module "hub_network_security_groups" {
  source   = "github.com/danielkhen/network_security_group_module"
  for_each = local.hub_network_security_groups_map

  name                   = each.value.name
  location               = local.location
  resource_group_name    = azurerm_resource_group.hub.name
  network_security_rules = each.value.network_security_rules
  log_analytics_id       = module.hub_log_analytics.id
}

locals {
  hub_route_tables     = jsondecode(templatefile("./objects/hub/route_tables.json", local.network_vars))
  hub_route_tables_map = { for rt in local.hub_route_tables : rt.name => rt }
}

module "hub_route_tables" {
  source   = "github.com/danielkhen/route_table_module"
  for_each = local.hub_route_tables_map

  name                = each.value.name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  routes              = each.value.routes
}

locals {
  hub_vnet_name           = "${local.prefix}-hub-vnet"
  hub_vnet_address_prefix = "10.0.0.0/16"

  hub_vnet_subnets_map = {
    GatewaySubnet = {
      address_prefix = cidrsubnet(local.hub_vnet_address_prefix, local.subnet_newbits, 0)
      route_table    = "hub-gateway-rt"
    }

    AzureFirewallSubnet = {
      address_prefix = cidrsubnet(local.hub_vnet_address_prefix, local.subnet_newbits, 1)
    }

    AzureFirewallManagementSubnet = {
      address_prefix = cidrsubnet(local.hub_vnet_address_prefix, local.subnet_newbits, 2)
    }

    ACRSubnet = {
      address_prefix         = cidrsubnet(local.hub_vnet_address_prefix, local.subnet_newbits, 3)
      network_security_group = "hub-ACRSubnet-nsg"
      route_table            = "hub-rt"
    }
  }

  hub_vnet_subnets = [
    for name, subnet in local.hub_vnet_subnets_map : merge(subnet, {
      name                      = name
      network_security_group_id = can(subnet.network_security_group) ? module.hub_network_security_groups[subnet.network_security_group].id : ""
      route_table_id            = can(subnet.route_table) ? module.hub_route_tables[subnet.route_table].id : ""
    })
  ]
}

module "hub_virtual_network" {
  source = "github.com/danielkhen/virtual_network_module"

  name                = local.hub_vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = [local.hub_vnet_address_prefix]
  subnets             = local.hub_vnet_subnets
}

locals {
  hub_vnet_gateway_name                  = "${local.prefix}-hub-vpn"
  hub_vnet_gateway_type                  = "Vpn"
  hub_vpn_type                           = "RouteBased"
  hub_vnet_gateway_ip_name               = "${local.prefix}-hub-vpn-default-ip"
  hub_vnet_gateway_active_active_ip_name = "${local.prefix}-hub-vpn-aa-ip"
  hub_vnet_gateway_active_active         = true
  hub_vpn_address_prefix                 = "172.0.0.0/16"
  hub_vnet_gateway_sku                   = "VpnGw1"
  hub_vnet_gateway_generation            = "Generation1"
  aad_audience                           = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
}

module "hub_vpn_gateway" {
  source = "github.com/danielkhen/virtual_network_gateway_module"

  name                = local.hub_vnet_gateway_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = local.hub_vnet_gateway_sku
  generation          = local.hub_vnet_gateway_generation
  type                = local.hub_vnet_gateway_type
  vpn_type            = local.hub_vpn_type
  log_analytics_id    = module.hub_log_analytics.id

  ip_name               = local.hub_vnet_gateway_ip_name
  subnet_id             = module.hub_virtual_network.subnet_ids["GatewaySubnet"]
  active_active         = local.hub_vnet_gateway_active_active
  active_active_ip_name = local.hub_vnet_gateway_active_active_ip_name

  vpn_address_space = [local.hub_vpn_address_prefix]
  aad_tenant        = var.aad_tenant_id
  aad_audience      = local.aad_audience
}

locals {
  hub_firewall_policy_name               = "${local.prefix}-hub-fw-pl"
  hub_firewall_policy_network_groups     = jsondecode(templatefile("./objects/hub/network_rule_collection_groups.json", local.network_vars))
  hub_firewall_policy_application_groups = jsondecode(templatefile("./objects/hub/application_rule_collection_groups.json", local.network_vars))
  hub_firewall_policy_nat_groups         = jsondecode(templatefile("./objects/hub/nat_rule_collection_groups.json", local.network_vars))
  hub_firewall_policy_dns_proxy          = true
}

module "hub_firewall_policy" {
  source = "github.com/danielkhen/firewall_policy_module"

  name                = local.hub_firewall_policy_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  dns_proxy_enabled   = local.hub_firewall_policy_dns_proxy

  # TODO remove temp rules
  # TODO check the aks rule (weird DNS)
  network_rule_collection_groups     = local.hub_firewall_policy_network_groups
  application_rule_collection_groups = local.hub_firewall_policy_application_groups
  nat_rule_collection_groups         = local.hub_firewall_policy_nat_groups
}

locals {
  hub_firewall_name               = "${local.prefix}-hub-fw"
  hub_firewall_ip_name            = "${local.prefix}-hub-fw-ip"
  hub_firewall_management_ip_name = "${local.prefix}-hub-fw-mng-ip"
  hub_firewall_sku_tier           = "Standard"
  hub_firewall_forced_tunneling   = true
}

module "hub_firewall" {
  source = "github.com/danielkhen/firewall_module"

  name                = local.hub_firewall_name
  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_tier            = local.hub_firewall_sku_tier
  subnet_id           = module.hub_virtual_network.subnet_ids["AzureFirewallSubnet"]
  policy_id           = module.hub_firewall_policy.id
  public_ip_name      = local.hub_firewall_ip_name
  log_analytics_id    = module.hub_log_analytics.id

  forced_tunneling          = local.hub_firewall_forced_tunneling
  management_public_ip_name = local.hub_firewall_management_ip_name
  management_subnet_id      = module.hub_virtual_network.subnet_ids["AzureFirewallManagementSubnet"]

  depends_on = [module.hub_virtual_network] # Sometimes the firewall blocks creation of other subnets
}

locals {
  hub_acr_name = "${local.prefix}hubacr"
  # TODO check if premium is needed
  hub_acr_sku                    = "Premium"
  hub_acr_network_access_enabled = false
}

# TODO create module acr and create acr and endpoint in it
resource "azurerm_container_registry" "hub_acr" {
  name                          = local.hub_acr_name
  location                      = local.location
  resource_group_name           = azurerm_resource_group.hub.name
  sku                           = local.hub_acr_sku
  public_network_access_enabled = local.hub_acr_network_access_enabled

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  hub_acr_dns_name                     = "privatelink.azurecr.io"
  hub_acr_nic_name                     = "${local.prefix}-hub-acr-nic"
  hub_acr_private_endpoint_name        = "${local.prefix}-hub-acr-pe"
  hub_acr_private_endpoint_subresource = "registry"

  hub_acr_vnet_links = [
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

module "hub_acr_private_endpoint" {
  source = "github.com/danielkhen/private_endpoint_module"

  location            = local.location
  resource_group_name = azurerm_resource_group.hub.name
  nic_name            = local.hub_acr_nic_name
  name                = local.hub_acr_private_endpoint_name
  private_dns_enabled = local.private_endpoints_dns_enabled
  dns_name            = local.hub_acr_dns_name
  log_analytics_id    = module.hub_log_analytics.id

  resource_id      = azurerm_container_registry.hub_acr.id
  subresource_name = local.hub_acr_private_endpoint_subresource
  subnet_id        = module.hub_virtual_network.subnet_ids["ACRSubnet"]
  vnet_links       = local.hub_acr_vnet_links
}