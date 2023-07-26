<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diagnostics_name"></a> [diagnostics\_name](#input\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the private dns resolver. | `string` | `"resolver-diagnostics"` | no |
| <a name="input_inbound_endpoint_name"></a> [inbound\_endpoint\_name](#input\_inbound\_endpoint\_name) | (Optional) The name of the inbound endpoint of the private dns resolver. | `string` | `"inbound"` | no |
| <a name="input_inbound_endpoint_subnet_id"></a> [inbound\_endpoint\_subnet\_id](#input\_inbound\_endpoint\_subnet\_id) | (Required) The subnet id of the inbound endpoint of the private dns resolver. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_enabled"></a> [log\_analytics\_enabled](#input\_log\_analytics\_enabled) | (Optional) Should all logs be sent to a log analytics workspace. | `bool` | `false` | no |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | (Required) The id of the virtual network linked to the private dns resolver. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the private dns resolver. |
| <a name="output_inbound_endpoint_ip"></a> [inbound\_endpoint\_ip](#output\_inbound\_endpoint\_ip) | The private ip address of the inbound endpoint of the private dns resolver. |
| <a name="output_name"></a> [name](#output\_name) | The name of the private dns resolver. |
| <a name="output_object"></a> [object](#output\_object) | The private dns resolver object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_resolver.resolver](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver_inbound_endpoint.inbound_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_resolver_inbound_endpoint) | resource |

## Modules

No modules.
<!-- END_TF_DOCS -->