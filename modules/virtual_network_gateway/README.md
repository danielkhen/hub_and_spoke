<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aa_ip_configuration_name"></a> [aa\_ip\_configuration\_name](#input\_aa\_ip\_configuration\_name) | (Optional) The name of the active-active ip configuration. | `string` | `"active-active"` | no |
| <a name="input_aa_pip_diagnostics_name"></a> [aa\_pip\_diagnostics\_name](#input\_aa\_pip\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the active-active public ip. | `string` | `"aa-pip-diagnostics"` | no |
| <a name="input_aa_pip_name"></a> [aa\_pip\_name](#input\_aa\_pip\_name) | (Optional) The name for the public ip of the active active ip configuration, Required if active-active mode is enabled. | `string` | `null` | no |
| <a name="input_aad_audience"></a> [aad\_audience](#input\_aad\_audience) | (Optional) The aad audience id, Required For aad authentication. | `string` | `null` | no |
| <a name="input_aad_tenant"></a> [aad\_tenant](#input\_aad\_tenant) | (Optional) The aad tenant id, Required for AAD authentication. | `string` | `null` | no |
| <a name="input_active_active"></a> [active\_active](#input\_active\_active) | (Required) Is the virtual network gateway in active active mode. | `bool` | n/a | yes |
| <a name="input_default_ip_configuration_name"></a> [default\_ip\_configuration\_name](#input\_default\_ip\_configuration\_name) | (Optional) The name of the default ip configuration. | `string` | `"default"` | no |
| <a name="input_default_pip_diagnostics_name"></a> [default\_pip\_diagnostics\_name](#input\_default\_pip\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the default public ip. | `string` | `"default-pip-diagnostics"` | no |
| <a name="input_default_pip_name"></a> [default\_pip\_name](#input\_default\_pip\_name) | (Required) The name for the public ip of the default ip configuration. | `string` | n/a | yes |
| <a name="input_generation"></a> [generation](#input\_generation) | (Optional) The generation of the virtual network gateway. | `string` | `"None"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the virtual network gateway. | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name for the virtual network gateway. | `string` | n/a | yes |
| <a name="input_radius_server_address"></a> [radius\_server\_address](#input\_radius\_server\_address) | (Optional) The address of the radius server, Required for radius authentication. | `string` | `null` | no |
| <a name="input_radius_server_secret"></a> [radius\_server\_secret](#input\_radius\_server\_secret) | (Optional) The secret of the radius server, Required for radius authentication. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the virtual network gateway. | `string` | n/a | yes |
| <a name="input_revoked_certificate"></a> [revoked\_certificate](#input\_revoked\_certificate) | (Optional) The revoked certificate block, Required for certificate authentication. | <pre>object({<br>    name       = string<br>    thumbprint = string<br>  })</pre> | `null` | no |
| <a name="input_root_certificate"></a> [root\_certificate](#input\_root\_certificate) | (Optional) The root certificate block, Required for certificate authentication. | <pre>object({<br>    name             = string<br>    public_cert_data = string<br>  })</pre> | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) The SKU of the virtual network gateway. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | (Required) The id of the gateway subnet | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | (Required) The type of the virtual network gateway, Vpn or ExpressRoute. | `string` | n/a | yes |
| <a name="input_vng_diagnostics_name"></a> [vng\_diagnostics\_name](#input\_vng\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the virtual network gateway. | `string` | `"vng-diagnostics"` | no |
| <a name="input_vpn_address_space"></a> [vpn\_address\_space](#input\_vpn\_address\_space) | (Optional) The vpn address space for client private ips. | `list(string)` | `null` | no |
| <a name="input_vpn_auth_types"></a> [vpn\_auth\_types](#input\_vpn\_auth\_types) | (Optional) List of vpn authentication types, AAD, Radius or Certificate, Required when using multiple vpn client protocols. | `list(string)` | <pre>[<br>  "AAD"<br>]</pre> | no |
| <a name="input_vpn_client_protocols"></a> [vpn\_client\_protocols](#input\_vpn\_client\_protocols) | (Optional) list of protocols supported by the vpn client, OpenVPN, SSTP or IkeV2. | `list(string)` | <pre>[<br>  "OpenVPN"<br>]</pre> | no |
| <a name="input_vpn_type"></a> [vpn\_type](#input\_vpn\_type) | (Optional) The type of the virtual network gateway, RouteBased or PolicyBased. | `string` | `"RouteBased"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the virtual network gateway. |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual network gateway. |
| <a name="output_object"></a> [object](#output\_object) | The virtual network gateway object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_public_ip.vng_aa_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.vng_default_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_network_gateway.vng](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aa_pip_diagnostics"></a> [aa\_pip\_diagnostics](#module\_aa\_pip\_diagnostics) | ../diagnostic_setting | n/a |
| <a name="module_default_pip_diagnostics"></a> [default\_pip\_diagnostics](#module\_default\_pip\_diagnostics) | ../diagnostic_setting | n/a |
| <a name="module_vng_diagnostics"></a> [vng\_diagnostics](#module\_vng\_diagnostics) | ../diagnostic_setting | n/a |
<!-- END_TF_DOCS -->