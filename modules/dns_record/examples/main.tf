module "dns_record" {
  source = "github.com/danielkhen/dns_record_module"

  name                = "example-name"
  resource_group_name = azurerm_resource_group.example.name
  dns_name            = "example-dns.com"
  is_private          = true
  record_type         = "a"
  records             = ["10.0.0.10"]
  vnet_links = [ # Links to vnets in the case of a private dns.
    {
      name    = "example-link"
      vnet_id = azurerm_virtual_network.example.id
    }
  ]
}