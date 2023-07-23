locals {
  ip_allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "vng_default_pip" {
  location            = var.location
  name                = var.default_pip_name
  resource_group_name = var.resource_group_name
  allocation_method   = local.ip_allocation_method

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

resource "azurerm_public_ip" "vng_aa_pip" {
  count = var.active_active ? 1 : 0

  location            = var.location
  name                = var.aa_pip_name
  resource_group_name = var.resource_group_name
  allocation_method   = local.ip_allocation_method

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  openvpn    = ["OpenVPN"] #TODO add those options
  aad        = ["AAD"]
  aad_tenant = sensitive("https://login.microsoftonline.com/${var.aad_tenant}/")
  aad_issuer = sensitive("https://sts.windows.net/${var.aad_tenant}/")
}

resource "azurerm_virtual_network_gateway" "vng" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = var.type
  vpn_type            = var.vpn_type
  sku                 = var.sku
  generation          = var.generation
  active_active       = var.active_active

  ip_configuration {
    name                          = var.default_ip_configuration_name
    private_ip_address_allocation = local.ip_allocation_method
    subnet_id                     = var.subnet_id
    public_ip_address_id          = azurerm_public_ip.vng_default_pip.id
  }

  dynamic "ip_configuration" {
    for_each = var.active_active ? [true] : []

    content {
      name                          = var.aa_ip_configuration_name
      private_ip_address_allocation = local.ip_allocation_method
      subnet_id                     = var.subnet_id
      public_ip_address_id          = azurerm_public_ip.vng_aa_pip[0].id
    }
  }

  dynamic "vpn_client_configuration" {
    for_each = var.vpn_address_space == null ? [] : [true]

    content {
      address_space        = var.vpn_address_space
      vpn_client_protocols = local.openvpn
      vpn_auth_types       = local.aad

      aad_tenant   = local.aad_tenant
      aad_audience = var.aad_audience
      aad_issuer   = local.aad_issuer
    }
  }

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

module "vng_diagnostics" {
  source = "../diagnostic_setting"

  name                       = var.vng_diagnostics_name
  target_resource_id         = azurerm_virtual_network_gateway.vng.id
  log_analytics_workspace_id = var.log_analytics_id
  enabled                    = var.log_analytics
}

module "default_pip_diagnostics" {
  source = "../diagnostic_setting"

  name                       = var.default_pip_diagnostics_name
  target_resource_id         = azurerm_public_ip.vng_default_pip.id
  log_analytics_workspace_id = var.log_analytics_id
  enabled                    = var.log_analytics
}

module "aa_pip_diagnostics" {
  source = "../diagnostic_setting"

  name                       = var.aa_pip_diagnostics_name
  target_resource_id         = azurerm_public_ip.vng_aa_pip[0].id
  log_analytics_workspace_id = var.log_analytics_id
  enabled                    = var.active_active && var.log_analytics
}