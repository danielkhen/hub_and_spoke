<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_forced_tunneling"></a> [forced\_tunneling](#input\_forced\_tunneling) | (Optional) Is forced tunneling enabled. | `bool` | `false` | no |
| <a name="input_fw_diagnostics_name"></a> [fw\_diagnostics\_name](#input\_fw\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the firewall. | `string` | `"fw-diagnostics"` | no |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | (Optional) The name of the default ip configuration. | `string` | `"fw-pip"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the firewall. | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_management_ip_configuration_name"></a> [management\_ip\_configuration\_name](#input\_management\_ip\_configuration\_name) | (Optional) The name of the management ip configuration. | `string` | `"fw-mng-pip"` | no |
| <a name="input_management_pip_diagnostics_name"></a> [management\_pip\_diagnostics\_name](#input\_management\_pip\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the management public ip. | `string` | `"fw-management-pip-diagnostics"` | no |
| <a name="input_management_public_ip_name"></a> [management\_public\_ip\_name](#input\_management\_public\_ip\_name) | (Optional) The name for the management public ip, Required if forced tunneling is enabled. | `string` | `null` | no |
| <a name="input_management_subnet_id"></a> [management\_subnet\_id](#input\_management\_subnet\_id) | (Optional) The id of the firewall management subnet, Required if forced tunneling is enabled. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the firewall. | `string` | n/a | yes |
| <a name="input_pip_diagnostics_name"></a> [pip\_diagnostics\_name](#input\_pip\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the default public ip. | `string` | `"fw-pip-diagnostics"` | no |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | (Required) The id of the firewall policy. | `string` | n/a | yes |
| <a name="input_public_ip_name"></a> [public\_ip\_name](#input\_public\_ip\_name) | (Required) The name for the regular public ip. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the firewall. | `string` | n/a | yes |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | (Required) The SKU tier of the firewall, Basic, Standard or Premium. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The id of the firewall subnet. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the firewall. |
| <a name="output_name"></a> [name](#output\_name) | The name of the firewall. |
| <a name="output_object"></a> [object](#output\_object) | The firewall object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall.fw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_public_ip.fw_mng_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.fw_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_fw_diagnostics"></a> [fw\_diagnostics](#module\_fw\_diagnostics) | ../diagnostic_setting | n/a |
| <a name="module_fw_mng_pip_diagnostics"></a> [fw\_mng\_pip\_diagnostics](#module\_fw\_mng\_pip\_diagnostics) | ../diagnostic_setting | n/a |
| <a name="module_fw_pip_diagnostics"></a> [fw\_pip\_diagnostics](#module\_fw\_pip\_diagnostics) | ../diagnostic_setting | n/a |
<!-- END_TF_DOCS -->