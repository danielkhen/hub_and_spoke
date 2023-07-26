<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) A list of the address prefixes of the virtual network. | `list(string)` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) A list of the dns servers of the virtual network. | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the virtual network. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the virtual network. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the virtual network. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Required) A list of all of the subnets in the virtual network. | <pre>list(object({<br>    name                               = string<br>    address_prefixes                   = list(string)<br>    network_security_group_id          = optional(string)<br>    network_security_group_association = optional(bool, true)<br>    route_table_id                     = optional(string)<br>    route_table_association            = optional(bool, true)<br>    dns_resolver_link                  = optional(bool, false)<br>    dns_resolver_delegation_name       = optional(string, "Microsoft.Network.dnsResolvers")<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the virtual network. |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network. |
| <a name="output_object"></a> [object](#output\_object) | The virtual network object. |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | A map for subnet name to address prefix. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | A map for subnet name to id. |

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.nsg_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.rt_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Modules

No modules.
<!-- END_TF_DOCS -->