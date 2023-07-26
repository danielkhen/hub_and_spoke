locals {
  location            = "westeurope"
  resource_group_name = "dtf-storage-account-test"
}

resource "azurerm_resource_group" "test_rg" {
  name     = local.resource_group_name
  location = local.location

  lifecycle {
    ignore_changes = [tags["CreationDateTime"], tags["Environment"]]
  }
}

locals {
  storage_account_name             = "dtfstorageaccountest"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind             = "BlobStorage"
}

module "storage_account" {
  source = "../../storage_account"

  name                     = local.storage_account_name
  location                 = local.location
  resource_group_name      = azurerm_resource_group.test_rg.name
  account_tier             = local.storage_account_tier
  account_replication_type = local.storage_account_replication_type
  account_kind             = local.storage_account_kind
}
