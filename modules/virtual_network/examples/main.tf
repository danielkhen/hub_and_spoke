module "vnet" {
  source = "github.com/danielkhen/virtual_network_module"

  name                = "example-vnet"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["11.0.0.10"]
  subnets             = local.vnet_subnets # View variable documentation
}
