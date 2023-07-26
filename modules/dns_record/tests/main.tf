locals {
  location            = "westeurope"
  resource_group_name = "dtf-dns-record-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  public_ip_name              = "public_ip"
  public_ip_allocation_method = "Static"
}

resource "azurerm_public_ip" "test_ip" {
  name                = local.public_ip_allocation_method
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  allocation_method   = local.public_ip_allocation_method

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  dns_record_name = "dns-record"
  dns_name        = "dns-test.com"
  dns_record_type = "a"
}

module "dns_record" {
  source = "../"

  name                = local.dns_record_name
  resource_group_name = azurerm_resource_group.test_rg.name
  dns_name            = local.dns_name
  record_type         = local.dns_record_type
  records             = [azurerm_public_ip.test_ip.ip_address]
}