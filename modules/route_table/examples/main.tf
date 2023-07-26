module "route_table" {
  source = "github.com/danielkhen/route_table_module"

  name                = "example-rt"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  routes              = local.routes # View variable documentation
}