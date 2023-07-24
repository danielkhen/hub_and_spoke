<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | (Required) The name of the private dns zone. | `string` | n/a | yes |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | (Optional) The name of the private endpoint in the private dns zone. | `string` | `"pe"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the private endpoint and private dns zone. | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_nic-diagnostics-name"></a> [nic-diagnostics-name](#input\_nic-diagnostics-name) | (Optional) The name of the diagnostic settings for the network interface. | `string` | `"pe-nic-diagnostics"` | no |
| <a name="input_nic_name"></a> [nic\_name](#input\_nic\_name) | (Required) The name of the network interface of the private endpoint. | `string` | n/a | yes |
| <a name="input_pe_name"></a> [pe\_name](#input\_pe\_name) | (Required) The name of the private endpoint. | `string` | n/a | yes |
| <a name="input_private_service_connection_name"></a> [private\_service\_connection\_name](#input\_private\_service\_connection\_name) | (Optional) The name of the private service connection. | `string` | `"private-connection"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The name of the resource group. | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | (Required) The resource id to associate with the private endpoint. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The subnet id for the private endpoint. | `string` | n/a | yes |
| <a name="input_subresource_name"></a> [subresource\_name](#input\_subresource\_name) | (Required) The subresource to associate with the private endpoint. | `string` | n/a | yes |
| <a name="input_vnet_links"></a> [vnet\_links](#input\_vnet\_links) | (Optional) A list of virtual networks to link with the dns zone. | <pre>list(object({<br>    vnet_id = string<br>    name    = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_id"></a> [dns\_id](#output\_dns\_id) | The id of the private dns zone. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | The name of the private dns zone. |
| <a name="output_dns_object"></a> [dns\_object](#output\_dns\_object) | The private dns zone object. |
| <a name="output_pe_id"></a> [pe\_id](#output\_pe\_id) | The id of the private endpoint. |
| <a name="output_pe_name"></a> [pe\_name](#output\_pe\_name) | The name of the private endpoint. |
| <a name="output_pe_object"></a> [pe\_object](#output\_pe\_object) | The object of the private endpoint. |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_links](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.pe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nic-diagnostics"></a> [nic-diagnostics](#module\_nic-diagnostics) | ../diagnostic_setting | n/a |
<!-- END_TF_DOCS -->