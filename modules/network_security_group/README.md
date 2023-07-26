<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diagnostic_settings_name"></a> [diagnostic\_settings\_name](#input\_diagnostic\_settings\_name) | (Optional) The name of the diagnostic settings. | `string` | `"network-security-group-diagnostics"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the network security group. | `string` | n/a | yes |
| <a name="input_log_analytics_enabled"></a> [log\_analytics\_enabled](#input\_log\_analytics\_enabled) | (Optional) Should all logs be sent to a log analytics workspace. | `bool` | `false` | no |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the network security group. | `string` | n/a | yes |
| <a name="input_network_security_rules"></a> [network\_security\_rules](#input\_network\_security\_rules) | (Optional) A list of network security rules. | <pre>list(object({<br>    name                       = string<br>    access                     = string<br>    direction                  = string<br>    priority                   = number<br>    protocol                   = string<br>    source_address_prefix      = string<br>    source_port_range          = string<br>    destination_address_prefix = string<br>    destination_port_range     = string<br>  }))</pre> | `[]` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the network security group. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the network security group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the network security group. |
| <a name="output_object"></a> [object](#output\_object) | The network security group object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_nsg_diagnostics"></a> [nsg\_diagnostics](#module\_nsg\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |

## Example Code

```hcl
module "network_security_group" {
  source = "github.com/danielkhen/network_security_group_module"

  name                   = "example-nsg"
  location               = "westeurope"
  resource_group_name    = azurerm_resource_group.example.name
  network_security_rules = local.network_security_rules # View variable documentation

  log_analytics_enabled = true
  log_analytics_id      = azurerm_log_analytics_workspace.example.id
}
```
<!-- END_TF_DOCS -->