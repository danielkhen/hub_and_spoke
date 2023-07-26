<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | (Optional) The access tier of the storage account. | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | (Optional) The kind of the storage account. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | (Required) The type of replication used for this storage account. | `string` | n/a | yes |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | (Required) The tier of the storage account. | `string` | n/a | yes |
| <a name="input_diagnostics_name"></a> [diagnostics\_name](#input\_diagnostics\_name) | (Optional) The name of the diagnostic settings of the storage account. | `string` | `"storage-diagnostics"` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | (Optional) Use only https traffic. | `bool` | `true` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required) The location of the storage account. | `string` | n/a | yes |
| <a name="input_log_analytics_enabled"></a> [log\_analytics\_enabled](#input\_log\_analytics\_enabled) | (Optional) Should all logs be sent to a log analytics workspace. | `bool` | `false` | no |
| <a name="input_log_analytics_id"></a> [log\_analytics\_id](#input\_log\_analytics\_id) | (Optional) The id of the log analytics workspace. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the storage account. | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | (Optional) Allow public network access. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) The resource group name of the storage account. | `string` | n/a | yes |
| <a name="input_subresources_diagnostics"></a> [subresources\_diagnostics](#input\_subresources\_diagnostics) | (Optional) A list of the subresource to add diagnostic settings to. | <pre>list(object({<br>    name             = string<br>    diagnostics_name = string<br>  }))</pre> | <pre>[<br>  {<br>    "diagnostics_name": "blob-diagnostics",<br>    "name": "blob"<br>  },<br>  {<br>    "diagnostics_name": "queue-diagnostics",<br>    "name": "queue"<br>  },<br>  {<br>    "diagnostics_name": "file-diagnostics",<br>    "name": "file"<br>  },<br>  {<br>    "diagnostics_name": "table-diagnostics",<br>    "name": "table"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the storage account. |
| <a name="output_name"></a> [name](#output\_name) | The name of the storage account. |
| <a name="output_object"></a> [object](#output\_object) | The storage account object. |

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_storage_diagnostics"></a> [storage\_diagnostics](#module\_storage\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |
| <a name="module_subresources_diagnostics"></a> [subresources\_diagnostics](#module\_subresources\_diagnostics) | github.com/danielkhen/diagnostic_setting_module | n/a |

## Example Code

```hcl
module "storage_account" {
  source = "github.com/danielkhen/storage_account_module"

  name                          = "example-storage"
  location                      = "westeurope"
  resource_group_name           = azurerm_resource_group.example.name
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "BlobStorage"
  enable_https_traffic_only     = true
  access_tier                   = "Hot"
  public_network_access_enabled = false

  log_analytics_enabled = true
  log_analytics_id      = azurerm_log_analytics_workspace.example.id
}
```
<!-- END_TF_DOCS -->