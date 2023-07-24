<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Optional) The log analytics workspace id to send logs to. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the diagnostic setting. | `string` | n/a | yes |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | (Optional) The storage account id to send logs to. | `string` | `null` | no |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | (Required) The resource id to enable logs on. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the diagnostic setting. |
| <a name="output_name"></a> [name](#output\_name) | The name of the diagnostic setting. |
| <a name="output_object"></a> [object](#output\_object) | The diagnostic setting object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Modules

No modules.
<!-- END_TF_DOCS -->