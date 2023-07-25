<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_diagnostic_settings_name"></a> [diagnostic\_settings\_name](#input\_diagnostic\_settings\_name) | (Optional) The name of the diagnostic settings. | `string` | `"log-analytics-workspace-diagnostics"` | no |
| <a name="input_internet_ingestion_enabled"></a> [internet\_ingestion\_enabled](#input\_internet\_ingestion\_enabled) | (Optional) Should the log analytics workspace support ingestion over the public internet. | `string` | `"true"` | no |
| <a name="input_internet_query_enabled"></a> [internet\_query\_enabled](#input\_internet\_query\_enabled) | (Optional) Should the log analytics workspace support querying over the public internet. | `string` | `"true"` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_log_analytics"></a> [log\_analytics](#input\_log\_analytics) | (Optional) capture logs and metrics. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the log analytics workspace. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) The SKU of the log analytics workspace. | `string` | `"PerGB2018"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the log analytics workspace |
| <a name="output_name"></a> [name](#output\_name) | The name of the log analytics workspace |
| <a name="output_object"></a> [object](#output\_object) | The log analytics workspace object |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_log_analytics_diagnostics"></a> [log\_analytics\_diagnostics](#module\_log\_analytics\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |
<!-- END_TF_DOCS -->