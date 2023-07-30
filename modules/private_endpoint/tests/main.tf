locals {
  location            = "westeurope"
  resource_group_name = "dtf-private-endpoint-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  vnet_name          = "vnet"
  vnet_address_space = ["10.0.0.0/16"]

  vnet_subnets = [
    {
      name           = "PESubnet"
      address_prefix = "10.0.0.0/24"
    }
  ]
}

module "vnet" {
  source = "../../virtual_network"

  name                = local.vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  address_space       = local.vnet_address_space
  subnets             = local.vnet_subnets
}

locals {
  storage_account_name             = "dtfprivateendpointtest"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
}

module "storage_account" {
  source = "../../storage_account"

  name                     = local.storage_account_name
  location                 = local.location
  resource_group_name      = azurerm_resource_group.test_rg.name
  account_tier             = local.storage_account_tier
  account_replication_type = local.storage_account_replication_type
}

locals {
  private_endpoint_name    = "pe"
  storage_subresource_name = "blob"
}

module "private_endpoint" {
  source = "../"

  name                = local.private_endpoint_name
  location            = local.location
  resource_group_name = azurerm_resource_group.test_rg.name
  subnet_id           = module.vnet.subnet_ids["PESubnet"]
  resource_id         = module.storage_account.id
  subresource_name    = local.storage_subresource_name
}