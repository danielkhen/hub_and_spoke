<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_forced_tunneling"></a> [forced\_tunneling](#input\_forced\_tunneling) | (Optional) Is forced tunneling enabled. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the firewall. | `string` | n/a | yes |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Required) The id of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_management_public_ip_name"></a> [management\_public\_ip\_name](#input\_management\_public\_ip\_name) | (Optional) The name for the management public ip, Required if forced tunneling is enabled. | `string` | `null` | no |
| <a name="input_management_subnet_id"></a> [management\_subnet\_id](#input\_management\_subnet\_id) | (Optional) The id of the firewall management subnet, Required if forced tunneling is enabled. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the firewall. | `string` | n/a | yes |
| <a name="input_policy_id"></a> [policy\_id](#input\_policy\_id) | (Optional) The id of the firewall policy. | `string` | `null` | no |
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
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) | resource |
| [azurerm_public_ip.ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.management_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall_diagnostics"></a> [firewall\_diagnostics](#module\_firewall\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |
| <a name="module_ip_diagnostics"></a> [ip\_diagnostics](#module\_ip\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |
| <a name="module_management_ip_diagnostics"></a> [management\_ip\_diagnostics](#module\_management\_ip\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |

## Example Code

```hcl
module "firewall" {
  source = "github.com/danielkhen/firewall_module"

  name                = "example-firewall"
  location            = "westeurope"
  resource_group_name = azurerm_resource_group.example.name
  policy_id           = azurerm_firewall_policy.example.id
  public_ip_name      = "example-public-ip"
  sku_tier            = "Standard"
  subnet_id           = azurerm_subnet.firewall_example.id

  forced_tunneling          = true # Forced tunneling requires another public ip
  management_public_ip_name = "example-management-public-ip"
  management_subnet_id      = azurerm_subnet.firewall_management_example.id
  log_analytics_id          = azurerm_log_analytics_workspace.example.id
}
```
<!-- END_TF_DOCS -->